import 'package:flutter/material.dart';
import 'package:krishi_connect_app/main_screen.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
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
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          Text('Krishi-Connect Login'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Enter number:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  width: width * 0.5,
                  height: 70,
                  child: TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.green,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Number',
                      floatingLabelStyle: TextStyle(color: Colors.green),
                      focusColor: Colors.green,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Enter Password:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  width: width * 0.5,
                  height: 70,
                  child: TextFormField(
                    controller: _passwordController,
                    cursorColor: Colors.green,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      floatingLabelStyle: TextStyle(color: Colors.green),
                      focusColor: Colors.green,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a name";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => isLoading ? null : _submitForm(),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(vertical: 5),
              width: width * 0.5,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
