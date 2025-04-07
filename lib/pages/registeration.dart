import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:krishi_connect_app/pages/login.dart';
import 'package:krishi_connect_app/pages/profile.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';
import 'package:krishi_connect_app/utils/navigation_helper.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class Registeration extends StatefulWidget {
  const Registeration({super.key});

  @override
  State<Registeration> createState() => _RegisterationState();
}

class _RegisterationState extends State<Registeration> {
  String _selectedRole = 'Farmer'; // Default selected value
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm() {
    print(_selectedRole);
    if (_formKey.currentState!.validate()) {
      NavigationHelper.push(
        context,
        Profile(
          name: _nameController.text,
          number: _numberController.text,
          role: _selectedRole,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please fill in all details correctly before proceeding')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTextStyles.appColor,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 110,
              ),
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
                    controller: _nameController,
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
                      labelText: 'Full Name',
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
                        return "Please enter a name";
                      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return "Enter a valid name (only letters)";
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z\s]+$')),
                    ],
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
                          color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 20),
                      floatingLabelStyle: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
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
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Register as:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRole = 'Farmer';
                      });
                    },
                    child: Container(
                      height: height * 0.05,
                      width: width * 0.38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _selectedRole == 'Farmer'
                            ? Color.fromRGBO(107, 142, 35, 1)
                            : Color.fromRGBO(139, 69, 19, 1),
                      ),
                      child: Center(
                        child: Text(
                          'FARMER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRole = 'Business';
                      });
                    },
                    child: Container(
                      height: height * 0.05,
                      width: width * 0.38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _selectedRole == 'Business'
                            ? Color.fromRGBO(107, 142, 35, 1)
                            : Color.fromRGBO(139, 69, 19, 1),
                      ),
                      child: Center(
                        child: Text(
                          'BUSINESS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () => _submitForm(),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  width: width * 0.9,
                  height: height * 0.055,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(85, 107, 47, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: AppTextStyles.buttonTextStyle,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text(
                'Already have an account? ',
                style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  fontSize: 18,
                ),
              ),
              GestureDetector(
                onTap: () {
                  NavigationHelper.push(context, LoginPage());
                },
                child: Text(
                  'Login Here',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
