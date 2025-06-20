import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:krishi_connect_app/pages/login.dart';
import 'package:krishi_connect_app/main_screen.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class Profile extends StatefulWidget {
  const Profile(
      {super.key,
      required this.name,
      required this.number,
      required this.role});

  final String name;
  final String number;
  final String role;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  String _state = 'N/A';
  String _city = 'N/A';
  bool _isLoading = false;
  bool _isPasswordHidden = true;

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
  }

  Future<void> _fetchLocationDetails() async {
    String pincode = _pincodeController.text.trim();

    if (pincode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid pincode")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final locationData = await RegisterService.getLocationFromPincode(pincode);

    setState(() {
      _isLoading = false;
      if (locationData != null) {
        _state = locationData['State'] ?? 'Unknown';
        _city = locationData['Name'] ?? 'Unknown';
      } else {
        _state = 'Not Found';
        _city = 'Not Found';
      }
    });
  }

  bool isRegistered = false;
  void registerNewUser() async {
    setState(() {
      isRegistered = true;
    });
    RegisterService apiService = RegisterService();

    var response = await apiService.registerUserWithImage(
      name: widget.name,
      email: _emailController.text,
      phone: widget.number,
      password: _passwordController2.text,
      role: widget.role,
      location: _city,
      profilePicFile: _selectedImage,
    );

    if (response.containsKey("error")) {
      print("Error: ${response['error']}");
      print("Error response full: $response");

      String errorMessage = response['error'].toString();
      if (errorMessage.contains("users.phone")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Phone number already exists!")),
        );
      } else if (errorMessage.contains("users.email")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email already exists!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Registration failed. Please try again.")),
        );
      }
      setState(() {
        isRegistered = false;
      });
    } else {
      print("User registered successfully: ${response}");

      setState(() {
        isRegistered = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Registration successfully. Please Login.")),
      );

      // Navigate to LoginPage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (route) => false,
      );
    }
  }

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColors.appColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/images/krishi_icon.png',
                  width: width * 0.26,
                ),
                Text('KrishiConnect', style: AppTextStyles.krishiHeading),
                SizedBox(
                  height: 10,
                ),
                Text('Complete Profile as ${widget.role}',
                    style: AppTextStyles.subHeadingStyle),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    height: 200,
                    width: 200,
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.camera_alt,
                            size: 50,
                          ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Name: ${widget.name}',
                        style: AppTextStyles.infoTextStyle),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Phone Num: ${widget.number}',
                        style: AppTextStyles.infoTextStyle),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: width * 0.52,
                          height: height * 0.055,
                          child: _buildTextField(_pincodeController, 'Pin code',
                              TextInputType.number)),
                      GestureDetector(
                        onTap: _fetchLocationDetails,
                        child: Container(
                          height: 50,
                          width: width * 0.3,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreenDark,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Search',
                                  style: AppTextStyles.buttonTextStyle,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('State: $_state \nCity: $_city',
                        style: AppTextStyles.infoTextStyle),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: width * 0.92,
                  height: 50,
                  child: _buildTextField(
                      _emailController, 'Email', TextInputType.emailAddress),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: width * 0.9,
                  height: 50,
                  child: _buildTextField(_passwordController1, 'Password',
                      TextInputType.visiblePassword,
                      obscure: true),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: width * 0.9,
                  height: 50,
                  child: _buildTextField(_passwordController2,
                      'Confirm Password', TextInputType.visiblePassword,
                      obscure: _isPasswordHidden,
                      suffix: IconButton(
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.remove_red_eye_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(
                            () => _isPasswordHidden = !_isPasswordHidden),
                      )),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: _validateAndRegister,
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: width * 0.9,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isRegistered
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Sign Up',
                            style: AppTextStyles.buttonTextStyle,
                          ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: Colors.black45,
                        ),
                        Text(
                          'Go Back',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, TextInputType type,
      {bool obscure = false, Widget? suffix}) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: obscure,
      cursorColor: Colors.black45,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black45, fontSize: 18),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _validateAndRegister() {
    if (_pincodeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController2.text.isEmpty ||
        _state == 'N/A' ||
        _city == 'N/A' ||
        _state == 'Not Found' ||
        _city == 'Not Found') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please fill in all details before proceeding")));
    } else if (!isValidEmail(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid email")));
    } else if (_passwordController1.text != _passwordController2.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")));
    } else {
      registerNewUser();
    }
  }
}
