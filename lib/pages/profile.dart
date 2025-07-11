import 'package:flutter/material.dart';
import 'package:krishi_connect_app/services/api/location_api.dart';
import 'package:krishi_connect_app/main_screen.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.name, required this.number});

  final String name;
  final String number;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _pincodeController = TextEditingController();
  String _state = 'N/A';
  String _city = 'N/A';
  bool _isLoading = false;

  Future<void> _fetchLocationDetails() async {
    String pincode = _pincodeController.text.trim();

    if (pincode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid pincode")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final locationData = await ApiService.getLocationFromPincode(pincode);

    setState(() {
      _isLoading = false;
      if (locationData != null) {
        _state = locationData['State'] ?? 'Unknown';
        _city = locationData['Name'] ?? 'Unknown';
      } else {
        _state = 'Not Found';
        _city = 'Not Found';
      }
    });
  }

  void completeRegistration(BuildContext context) async {
    await SharedPrefHelper.setRegistered(true);
    await SharedPrefHelper.setUsername(widget.name);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(SharedPrefHelper.getUserrole());
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Align(
                alignment: Alignment.center,
                child: const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Name:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    width: width * 0.5,
                    height: 40,
                    padding: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.grey,
                      border: Border.all(
                        width: 2,
                      ),
                    ),
                    child: Text(
                      (widget.name).toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Number:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    width: width * 0.5,
                    height: 40,
                    padding: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.grey,
                      border: Border.all(
                        width: 2,
                      ),
                    ),
                    child: Text(
                      widget.number,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enter Pincode:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.5,
                    height: 40,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _pincodeController,
                      cursorColor: Colors.green,
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Pincode',
                        floatingLabelStyle: TextStyle(color: Colors.green),
                        focusColor: Colors.green,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _fetchLocationDetails,
                child: Container(
                  height: 50,
                  width: width * 0.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Get Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'State:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    width: width * 0.5,
                    height: 40,
                    padding: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.grey,
                      border: Border.all(
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _state,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'City:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    width: width * 0.5,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.grey,
                      border: Border.all(
                        width: 2,
                      ),
                    ),
                    child: Text(
                      _city,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  if (_pincodeController.text.isEmpty ||
                      _state == 'N/A' ||
                      _city == 'N/A' ||
                      _state == 'Not Found' ||
                      _city == 'Not Found') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Please fill in all details before proceeding")),
                    );
                  } else {
                    completeRegistration(context);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: width * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
