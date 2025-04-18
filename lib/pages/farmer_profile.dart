import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:krishi_connect_app/pages/login.dart';
import 'package:krishi_connect_app/pages/registeration.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
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
          title: Text(
            'My Profile',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(107, 142, 35, 1),
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
                    // buildCard(farmerData['role']),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          farmerData['location'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(0, 0, 0, 0.75),
                          ),
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
                          color: Color.fromRGBO(85, 107, 47, 1),
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
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
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(228, 225, 215, 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(0, 0, 0, 0.5),
                fontWeight: FontWeight.w400),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit_outlined,
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
