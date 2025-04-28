import 'package:flutter/material.dart';
import 'package:krishi_connect_app/data/farmer_data.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class SearchPageFarmer extends StatefulWidget {
  const SearchPageFarmer({super.key});

  @override
  State<SearchPageFarmer> createState() => _SearchPageFarmerState();
}

class _SearchPageFarmerState extends State<SearchPageFarmer> {
  List<Map<String, dynamic>> business = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBusiness();
  }

  RegisterService service = RegisterService();

  Future<void> fetchBusiness() async {
    final token = SharedPrefHelper.getToken();

    final result = await service.getUserByRole(token: token, role: "BUSINESS");

    setState(() {
      business = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Search',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: [
            SizedBox(
              height: height * 0.8,
              child: business.isEmpty
                  ? Center(
                      child: Text('No Business Found'),
                    )
                  : ListView.builder(
                      itemCount: business.length,
                      itemBuilder: (context, index) {
                        return searchCard(business[index]);
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchCard(dynamic farmer) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green, width: 2),
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
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    farmer['name'],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Number:\t',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    farmer['phone'],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'State:\t',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    farmer['location'],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Text(
              //       'Crop:\t',
              //       style: TextStyle(
              //         fontSize: 15,
              //       ),
              //     ),
              //     Text(
              //       farmer.crop,
              //       style: TextStyle(
              //         fontSize: 15,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
