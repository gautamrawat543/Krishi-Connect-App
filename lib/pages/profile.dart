import 'package:flutter/material.dart';
import 'package:krishi_connect_app/pages/login.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.name, required this.number, required this.role});

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
  bool isRegistered = false;

  bool isValidEmail(String email) =>
      RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}").hasMatch(email);

  Future<void> _fetchLocationDetails() async {
    String pincode = _pincodeController.text.trim();
    if (pincode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid pincode")));
      return;
    }
    setState(() => _isLoading = true);
    final locationData = await RegisterService.getLocationFromPincode(pincode);
    setState(() {
      _isLoading = false;
      _state = locationData?['State'] ?? 'Not Found';
      _city = locationData?['Name'] ?? 'Not Found';
    });
  }

  void registerNewUser() async {
    setState(() => isRegistered = true);
    var response = await RegisterService().registerUser(
      name: widget.name,
      email: _emailController.text,
      phone: widget.number,
      password: _passwordController2.text,
      role: widget.role,
      location: _city,
      profilePicture: "https://example.com/profile.jpg",
    );

    setState(() => isRegistered = false);

    if (response.containsKey("error")) {
      final error = response['error'].toString();
      String message = error.contains("users.phone")
          ? "Phone number already exists!"
          : error.contains("users.email")
              ? "Email already exists!"
              : "Registration failed. Please try again.";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration successful. Please login.")));
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/images/krishi_icon.png', width: width * 0.26),
                    const Text('KrishiConnect', style: AppTextStyles.krishiHeading),
                    const SizedBox(height: 20),
                    Text('Complete Profile as ${widget.role}', style: AppTextStyles.subHeadingStyle),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Name: ${widget.name}', style: AppTextStyles.infoTextStyle),
              Text('Phone Num: ${widget.number}', style: AppTextStyles.infoTextStyle),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildTextField(_pincodeController, 'Pin code', TextInputType.number)),
                  const SizedBox(width: 10),
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
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Search', style: AppTextStyles.buttonTextStyle),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('State: $_state  City: $_city', style: AppTextStyles.infoTextStyle),
              const SizedBox(height: 20),
              _buildTextField(_emailController, 'Email', TextInputType.emailAddress),
              const SizedBox(height: 15),
              _buildTextField(_passwordController1, 'Password', TextInputType.visiblePassword, obscure: true),
              const SizedBox(height: 15),
              _buildTextField(_passwordController2, 'Confirm Password', TextInputType.visiblePassword,
                  obscure: _isPasswordHidden,
                  suffix: IconButton(
                    icon: Icon(
                      _isPasswordHidden ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
                  )),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _validateAndRegister,
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: width,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: isRegistered
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign Up', style: AppTextStyles.buttonTextStyle),
                ),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.black45),
                    Text('Go Back', style: TextStyle(fontSize: 18, color: Colors.black45))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType type,
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
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all details before proceeding")));
    } else if (!isValidEmail(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid email")));
    } else if (_passwordController1.text != _passwordController2.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
    } else {
      registerNewUser();
    }
  }
}
