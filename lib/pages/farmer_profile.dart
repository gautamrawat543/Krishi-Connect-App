import 'package:flutter/material.dart';
import 'package:krishi_connect_app/pages/login.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';
import 'package:krishi_connect_app/utils/app_styles.dart'; 

class FarmerProfile extends StatefulWidget {
  const FarmerProfile({super.key});

  @override
  State<FarmerProfile> createState() => _FarmerProfileState();
}

class _FarmerProfileState extends State<FarmerProfile> {
  Map<String, dynamic> farmerData = {};

  @override
  void initState() {
    super.initState();
    loadFarmerProfile();
  }

  RegisterService apiService = RegisterService();

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
          title: const Text(
            'My Profile',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryGreenDark,
        ),
        body: farmerData.isEmpty
            ? const Center(child: CircularProgressIndicator(color: Colors.green))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      height: 160,
                      width: 160,
                      margin: const EdgeInsets.only(right: 10),
                      child: Image.asset(
                        'assets/app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 30),
                    buildCard(farmerData['name']),
                    const SizedBox(height: 15),
                    buildCard('+91 ${farmerData['phone']}'),
                    const SizedBox(height: 15),
                    buildCard(farmerData['email']),
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 15),
                    buildCard('Edit Password'),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: () async {
                        await SharedPrefHelper.clearAll();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(vertical: 15),
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
                            const SizedBox(width: 10),
                            const Text(
                              'LogOut',
                              style: AppTextStyles.buttonTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
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
