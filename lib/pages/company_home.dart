import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:krishi_connect_app/data/company_listing.dart';
import 'package:krishi_connect_app/data/farmer_data.dart';
import 'package:krishi_connect_app/pages/search_page.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class CompanyHome extends StatefulWidget {
  const CompanyHome({super.key});

  @override
  State<CompanyHome> createState() => _CompanyHomeState();
}

class _CompanyHomeState extends State<CompanyHome> {
  List<dynamic> farmers = [];

@override
  void initState() {
    super.initState();
    loadFarmers();
  }

  RegisterService service = RegisterService();
  Future<void> loadFarmers() async {
    try {
      final listings =
          await service.getFarmer(token: SharedPrefHelper.getToken());
      setState(() {
        // Ensure the UI updates after data fetch
        farmers = listings;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Hello ${SharedPrefHelper.getUsername().toUpperCase()}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 5,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                'Farmer\'s OnBoarded',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: height * 0.2,
                child: farmers.isEmpty
                    ? Center(
                        child: Text('No Farmers Found'),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: farmers.length,
                        itemBuilder: (context, index) {
                          return searchCard(farmers[index]);
                        }),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Listings',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: Colors.green,
                    size: 30,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: height * 0.5,
                child: ListView.builder(
                    itemCount: sampleListings.length,
                    itemBuilder: (context, index) {
                      return listingCard(width, sampleListings[index], context);
                    }),
              ),
            ],
          ),
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
              Row(
                children: [
                  Text(
                    'Crop:\t',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    farmer['role'],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget listingCard(
      double width, CompanyListing listing, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
      ),
      width: width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'C.Name',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(listing.companyName, style: TextStyle(fontSize: 15)),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Product',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(listing.product, style: TextStyle(fontSize: 15)),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Quantity',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(listing.quantity.toString(),
                      style: TextStyle(fontSize: 15)),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => showListingDetails(context, listing),
                child: Container(
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 2),
                        color: Colors.green),
                    child: Text('Show Details')),
              ),
              Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      color: Colors.green),
                  child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }

  void showListingDetails(BuildContext context, CompanyListing listing) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Company: ${listing.companyName}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Product: ${listing.product}',
                  style: TextStyle(fontSize: 16)),
              Text('Quantity: ${listing.quantity.toString()}',
                  style: TextStyle(fontSize: 16)),
              Text('Price: ${listing.price.toString()}',
                  style: TextStyle(fontSize: 16)),
              Text('Description: ${listing.description}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        );
      },
    );
  }
}
