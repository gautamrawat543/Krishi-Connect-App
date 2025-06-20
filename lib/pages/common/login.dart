import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:krishi_connect_app/main_screen.dart';
import 'package:krishi_connect_app/pages/common/registeration.dart';
import 'package:krishi_connect_app/services/api/api_service.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';
import 'package:krishi_connect_app/utils/navigation_helper.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _numberController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  bool isLoading = false;
  void _submitForm() async {
    if (_numberController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all details correctly.')),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    ApiService service = ApiService();
    Map<String, dynamic> response = await service.loginUser(
        phone: _numberController.text, password: _passwordController.text);
    setState(() {
      isLoading = false;
    });
    if (response.containsKey("error")) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["error"])),
      );
    } else {
      // Assuming response contains user role
      String token = response["token"];
      print(token);
      Map<String, dynamic> userDetail = await service.getUserByPhone(
          phone: _numberController.text, token: token);
      print(userDetail);
      SharedPrefHelper.setRegistered(true);
      SharedPrefHelper.setToken(token);
      SharedPrefHelper.setUserrole(userDetail["role"]);
      SharedPrefHelper.setUsername(userDetail["name"]);
      SharedPrefHelper.setUserId(userDetail["userId"].toString());
      SharedPrefHelper.setLocation(userDetail["location"]);

      // Navigate to MainScreen
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Image.asset(
              'assets/images/krishi_icon.png',
              width: width * 0.35,
            ),
            Text(
              'KrishiConnect',
              style: AppTextStyles.krishiHeading,
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SizedBox(
                width: width * 0.9,
                height: 70,
                child: TextFormField(
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  cursorColor: AppColors.labelColor,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: customInputDecoration("Phone Number"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a number";
                    } else if (value.length != 10 ||
                        !RegExp(r'^\d{10}$').hasMatch(value)) {
                      return "Enter a valid 10-digit number";
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SizedBox(
                width: width * 0.9,
                height: 70,
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _isPasswordHidden,
                  cursorColor: AppColors.labelColor,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: customInputDecoration(
                    "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.remove_red_eye_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () => isLoading ? null : _submitForm(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: width * 0.9,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Login',
                        style: AppTextStyles.buttonTextStyle,
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            SizedBox(height: 50),
            Text('Don\'t have an account? ', style: AppTextStyles.bottomText),
            GestureDetector(
              onTap: () {
                NavigationHelper.push(context, Registeration());
              },
              child: Text('SignUp Here', style: AppTextStyles.linkText),
            ),
          ],
        ),
      ),
    );
  }
}
