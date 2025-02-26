import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:krishi_connect_app/pages/registeration.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class FarmerProfile extends StatelessWidget {
  const FarmerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Farmer\'s Profile',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 90,
                      margin: EdgeInsets.only(right: 10),
                      child: Image.asset(
                        'assets/app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Name:\t',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              SharedPrefHelper.getUsername().toUpperCase(),
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Number:\t',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '+91 ',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'State:\t',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Maharshtra',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Crops',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              buildCard('Add Crop'),
              buildCard('Edit Crop'),
              buildCard('Delete Crop'),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              buildCard('Edit Name'),
              buildCard('Edit Number'),
              buildCard('Edit State'),
              GestureDetector(
                onTap: () async {
                  await SharedPrefHelper.clearAll();
                  // Navigate to Registration Page and remove all previous routes
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Registeration()),
                    (route) =>
                        false, // This removes all previous screens from the stack
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(String title) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add_circle_outline_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
