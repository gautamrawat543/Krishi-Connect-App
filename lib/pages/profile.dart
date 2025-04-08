import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
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
  final TextEditingController _passwordController = TextEditingController();
  String _state = 'N/A';
  String _city = 'N/A';
  bool _isLoading = false;

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

    var response = await apiService.registerUser(
      name: widget.name,
      email: _emailController.text,
      phone: widget.number,
      password: _passwordController.text,
      role: widget.role,
      location: _city,
      profilePicture: "https://example.com/profile.jpg",
    );

    if (response.containsKey("error")) {
      print("Error: ${response['error']}");
      setState(() {
        isRegistered = false;
      });
    } else {
      print("User registered successfully: ${response}");

      setState(() {
        isRegistered = false;
      });

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppTextStyles.appColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'assets/images/krishi_icon.png',
                  width: width * 0.26,
                ),
                Text(
                  'KrishiConnect',
                  style: TextStyle(
                    color: Color.fromRGBO(29, 145, 67, 1),
                    fontSize: 36,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Complete Profile as ${widget.role}',
                  style: TextStyle(
                    color: Color.fromRGBO(29, 145, 67, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Name: ${widget.name}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Phone Num: ${widget.number}',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
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
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _pincodeController,
                          cursorColor: Color.fromRGBO(0, 0, 0, 0.5),
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2),
                            ),
                            labelText: 'Pin code',
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                                fontSize: 18),
                            floatingLabelStyle:
                                TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                            focusColor: Color.fromRGBO(0, 0, 0, 0.5),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _fetchLocationDetails,
                        child: Container(
                          height: height * 0.055,
                          width: width * 0.3,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(107, 142, 35, 1),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'State: $_state',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'City: $_city',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: width * 0.92,
                  height: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    cursorColor: Color.fromRGBO(0, 0, 0, 0.5),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 18),
                      floatingLabelStyle: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                      focusColor: Colors.green,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: width * 0.9,
                  height: 50,
                  child: TextFormField(
                    controller: _passwordController,
                    cursorColor: Color.fromRGBO(0, 0, 0, 0.5),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 18),
                      floatingLabelStyle:
                          TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                      focusColor: Color.fromRGBO(0, 0, 0, 0.5),
                      suffixIcon: Icon(Icons.remove_red_eye_outlined),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: width * 0.9,
                  height: 50,
                  child: TextFormField(
                    controller: _passwordController,
                    cursorColor: Color.fromRGBO(0, 0, 0, 0.5),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 18),
                      floatingLabelStyle:
                          TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),
                      focusColor: Color.fromRGBO(0, 0, 0, 0.5),
                      suffixIcon: Icon(Icons.remove_red_eye_outlined),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    if (_pincodeController.text.isEmpty ||
                        _emailController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _state == 'N/A' ||
                        _city == 'N/A' ||
                        _state == 'Not Found' ||
                        _city == 'Not Found') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Please fill in all details before proceeding")),
                      );
                    } else if (!isValidEmail(_emailController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter a valid email")),
                      );
                      return;
                    } else {
                      registerNewUser();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: width * 0.9,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(85, 107, 47, 1),
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
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                        Text(
                          'Go Back',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 20,
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
}
