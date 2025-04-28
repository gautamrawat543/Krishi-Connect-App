import 'package:flutter/material.dart';
import 'package:krishi_connect_app/data/farmer_data.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Map<String, dynamic>> farmers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFarmers();
  }

  RegisterService service = RegisterService();

  Future<void> fetchFarmers() async {
    final token = SharedPrefHelper.getToken();

    final result = await service.getUserByRole(token: token, role: "FARMER");

    setState(() {
      farmers = result;
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
              child: farmers.isEmpty
                  ? Center(
                      child: Text('No Farmers Found'),
                    )
                  : ListView.builder(
                      itemCount: farmers.length,
                      itemBuilder: (context, index) {
                        return searchCard(farmers[index]);
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
