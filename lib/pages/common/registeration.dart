import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:krishi_connect_app/pages/common/login.dart';
import 'package:krishi_connect_app/pages/common/detail_register.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:krishi_connect_app/utils/navigation_helper.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class Registeration extends StatefulWidget {
  const Registeration({super.key});

  @override
  State<Registeration> createState() => _RegisterationState();
}

class _RegisterationState extends State<Registeration> {
  String _selectedRole = ''; // Default selected value
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedRole = AppLocalizations.of(context)!.farmer;
  }

  void _submitForm() {
    print(_selectedRole);
    if (_formKey.currentState!.validate()) {
      NavigationHelper.push(
        context,
        DetailRegister(
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
      backgroundColor: AppColors.appColor,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Image.asset(
                'assets/images/krishi_icon.png',
                width: width * 0.35,
              ),
              Text(
                AppLocalizations.of(context)!.appTitle,
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
                    controller: _nameController,
                    cursorColor: AppColors.labelColor,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    decoration: customInputDecoration(
                        AppLocalizations.of(context)!.fullName),
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
                    cursorColor: AppColors.labelColor,
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    decoration: customInputDecoration(
                        AppLocalizations.of(context)!.phoneNumber),
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
                  child: Text('${AppLocalizations.of(context)!.registerAs}',
                      style: AppTextStyles.bottomText.copyWith(fontSize: 16)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _roleButton(context, width, height,
                      AppLocalizations.of(context)!.farmer),
                  _roleButton(context, width, height,
                      AppLocalizations.of(context)!.business),
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
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.continueBtn,
                      style: AppTextStyles.buttonTextStyle,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Text(AppLocalizations.of(context)!.alreadyAccount,
                  style: AppTextStyles.bottomText),
              GestureDetector(
                onTap: () {
                  NavigationHelper.push(context, LoginPage());
                },
                child: Text(AppLocalizations.of(context)!.loginHere,
                    style: AppTextStyles.linkText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleButton(
      BuildContext context, double width, double height, String role) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        height: height * 0.05,
        width: width * 0.38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? AppColors.primaryGreen : AppColors.red,
        ),
        child: Center(
          child: Text(
            role.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
