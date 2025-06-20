import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:krishi_connect_app/pages/common/login.dart';
import 'package:krishi_connect_app/pages/common/registeration.dart';
import 'package:krishi_connect_app/services/api/api_service.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class FarmerProfile extends StatefulWidget {
  const FarmerProfile({super.key});

  @override
  State<FarmerProfile> createState() => _FarmerProfileState();
}

class _FarmerProfileState extends State<FarmerProfile> {
  Map<String, dynamic> farmerData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFarmerProfile();
  }

  ApiService apiService = ApiService();
  Future<void> loadFarmerProfile() async {
    try {
      final data = await apiService.getUserProfile(
        token: SharedPrefHelper.getToken(),
        userId: SharedPrefHelper.getUserId(),
      );
      setState(() {
        farmerData = data;
      });
    } catch (e) {
      print('User by ID Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'My Profile',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryGreenDark,
        ),
        body: farmerData.isEmpty
            ? Center(child: CircularProgressIndicator(color: Colors.green))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      height: 160,
                      width: 160,
                      margin: EdgeInsets.only(right: 10),
                      child: Image.asset(
                        'assets/app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    buildCard(farmerData['name']),
                    SizedBox(
                      height: 15,
                    ),
                    buildCard('+91 ${farmerData['phone']}'),
                    SizedBox(
                      height: 15,
                    ),
                    buildCard(farmerData['email']),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          farmerData['location'],
                          style: AppTextStyles.cardSubText,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    buildCard('Edit Password'),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await SharedPrefHelper.clearAll();
                        // Navigate to Registration Page and remove all previous routes
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) =>
                              false, // This removes all previous screens from the stack
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primaryGreen,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logout.png',
                              color: Colors.white,
                              height: 20,
                            ),
                            Text(
                              'LogOut',
                              style: AppTextStyles.buttonTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildCard(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.appColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: AppTextStyles.labelStyle,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit_outlined,
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
