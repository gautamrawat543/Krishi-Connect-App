import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:krishi_connect_app/main_screen.dart';
import 'package:krishi_connect_app/pages/registeration.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
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
    RegisterService service = RegisterService();
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
      backgroundColor: AppTextStyles.appColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/krishi_icon.png',
            width: width * 0.35,
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
                cursorColor: Color.fromRGBO(0, 0, 0, 0.5),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    fontSize: 20,
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    fontSize: 20,
                  ),
                  focusColor: Color.fromRGBO(0, 0, 0, 0.5),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
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
                cursorColor: Color.fromRGBO(0, 0, 0, 0.5),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      fontSize: 20,
                    ),
                    floatingLabelStyle: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                    focusColor: Color.fromRGBO(0, 0, 0, 0.5),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    suffixIcon: Icon(Icons.remove_red_eye_outlined)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
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
              // margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: width * 0.9,
              decoration: BoxDecoration(
                color: Color.fromRGBO(85, 107, 47, 1),
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
          SizedBox(height: 50),
          Text(
            'Don\'t have an account? ',
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              fontSize: 18,
            ),
          ),
          GestureDetector(
            onTap: () {
              NavigationHelper.push(context, Registeration());
            },
            child: Text(
              'SignUp Here',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     NavigationHelper.push(context, Registeration());
          //   },
          //   child: Text.rich(
          //     TextSpan(
          //       text: 'Don\'t have an account? ',
          //       style: TextStyle(
          //         color: Color.fromRGBO(0, 0, 0, 0.5),
          //         fontSize: 16,
          //       ),
          //       children: [
          //         TextSpan(
          //           text: 'Register Here',
          //           style: TextStyle(
          //             color: Colors.green,
          //             fontWeight: FontWeight.bold,
          //             fontSize: 16,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
