import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:krishi_connect_app/data/company_listing.dart';
import 'package:krishi_connect_app/data/farmer_data.dart';
import 'package:krishi_connect_app/data/produce_data.dart';
import 'package:krishi_connect_app/pages/buyer_listing.dart';
import 'package:krishi_connect_app/pages/create_listing.dart';
import 'package:krishi_connect_app/pages/edit_listing.dart';
import 'package:krishi_connect_app/pages/search_page_business.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
import 'package:krishi_connect_app/utils/navigation_helper.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class CompanyHome extends StatefulWidget {
  const CompanyHome({super.key});

  @override
  State<CompanyHome> createState() => _CompanyHomeState();
}

class _CompanyHomeState extends State<CompanyHome> {
  List<dynamic> farmers = [];
  bool isLoadingFarmers = true;
  List<dynamic> companyListings = [];
  bool isLoadingCompanyListings = true;
  List<dynamic> produceListings = [];
  bool isLoadingProduceListings = true;

  String isSelected = 'All';

  @override
  void initState() {
    super.initState();
    loadFarmers();
    loadCompanyListings();
    loadProduce();
  }

  RegisterService service = RegisterService();

  Future<void> loadProduce() async {
    try {
      final listings =
          await service.getFarmerListing(token: SharedPrefHelper.getToken());
      setState(() {
        // Ensure the UI updates after data fetch
        produceListings = listings;
        isLoadingProduceListings = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoadingProduceListings = false;
      });
    }
  }

  Future<void> loadFarmers() async {
    try {
      final listings =
          await service.getFarmer(token: SharedPrefHelper.getToken());
      setState(() {
        // Ensure the UI updates after data fetch
        farmers = listings;
        isLoadingFarmers = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoadingFarmers = false;
      });
    }
  }

  Future<void> loadCompanyListings() async {
    try {
      final listing = await service.getBuyerRequestById(
          token: SharedPrefHelper.getToken(),
          businessId: SharedPrefHelper.getUserId());
      setState(() {
        // Ensure the UI updates after data fetch
        companyListings = listing;
        isLoadingCompanyListings = false;
        print("companyListings : ${companyListings}");
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoadingCompanyListings = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(107, 142, 35, 1),
        leading: Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                'Welcome back\n${SharedPrefHelper.getUsername().toUpperCase()}!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Produce',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'See All>',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(107, 142, 35, 1)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Divider(thickness: 2, color: Color.fromRGBO(107, 142, 35, 1)),
              SizedBox(
                height: 8,
              ),
              //available produce listing
              SizedBox(
                height: height * 0.38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: produceListings.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: availableProduceListing(
                        width,
                        produceListings[index],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create a Request',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 0.75)),
                  ),
                  GestureDetector(
                    onTap: () =>
                        NavigationHelper.push(context, CreateListing()),
                    child: Icon(
                      Icons.add_circle_outline_rounded,
                      color: Color.fromRGBO(0, 0, 0, 0.75),
                      size: 45,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Listings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      NavigationHelper.push(
                          context,
                          BuyerListing(
                            companyListings: companyListings,
                          ));
                    },
                    child: Text(
                      'See All>',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(107, 142, 35, 1)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Divider(thickness: 2, color: Color.fromRGBO(107, 142, 35, 1)),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected = 'All';
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: isSelected == 'All'
                            ? Color.fromRGBO(0, 0, 0, 0.75)
                            : Color.fromRGBO(0, 0, 0, 0.3),
                      ),
                      child: Center(
                        child: Text(
                          'All',
                          style: TextStyle(
                              color: isSelected == 'All'
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected = 'Open';
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: isSelected == 'Open'
                            ? Color.fromRGBO(0, 0, 0, 0.75)
                            : Color.fromRGBO(0, 0, 0, 0.3),
                      ),
                      child: Center(
                        child: Text(
                          'Open',
                          style: TextStyle(
                              color: isSelected == 'Open'
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelected = 'Closed';
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: isSelected == 'Closed'
                            ? Color.fromRGBO(0, 0, 0, 0.75)
                            : Color.fromRGBO(0, 0, 0, 0.3),
                      ),
                      child: Center(
                        child: Text(
                          'Closed',
                          style: TextStyle(
                              color: isSelected == 'Closed'
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   height: height * 0.2,
              //   child: isLoadingFarmers
              //       ? Center(
              //           child: CircularProgressIndicator(color: Colors.green))
              //       : farmers.isEmpty
              //           ? Center(
              //               child: Text('No Farmers Found'),
              //             )
              //           : ListView.builder(
              //               scrollDirection: Axis.horizontal,
              //               itemCount: farmers.length,
              //               itemBuilder: (context, index) {
              //                 return searchCard(farmers[index]);
              //               }),
              // ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: height * 0.5,
                child: isLoadingCompanyListings
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.green))
                    : companyListings.isEmpty
                        ? Center(
                            child: Text('No Listings Found'),
                          )
                        : ListView.builder(
                            itemCount: companyListings.length > 5
                                ? 5
                                : companyListings.length,
                            itemBuilder: (context, index) {
                              return listingCard(
                                width,
                                companyListings[index],
                              );
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

  // Widget listingCard(double width, dynamic listing, BuildContext context) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
  //     padding: EdgeInsets.all(5),
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //         color: Colors.green,
  //         width: 2,
  //       ),
  //     ),
  //     width: width,
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Column(
  //               children: [
  //                 Text(
  //                   'C.Name',
  //                   style: TextStyle(fontSize: 18),
  //                 ),
  //                 Text(listing['businessId'].toString(),
  //                     style: TextStyle(fontSize: 15)),
  //               ],
  //             ),
  //             Column(
  //               children: [
  //                 Text(
  //                   'Product',
  //                   style: TextStyle(fontSize: 18),
  //                 ),
  //                 Text(listing['category'], style: TextStyle(fontSize: 15)),
  //               ],
  //             ),
  //             Column(
  //               children: [
  //                 Text(
  //                   'Quantity',
  //                   style: TextStyle(fontSize: 18),
  //                 ),
  //                 Text(listing['requiredQuantity'].toString(),
  //                     style: TextStyle(fontSize: 15)),
  //               ],
  //             ),
  //           ],
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             GestureDetector(
  //               onTap: () => showListingDetails(context, listing),
  //               child: Container(
  //                   margin: EdgeInsets.all(5),
  //                   padding: EdgeInsets.all(5),
  //                   decoration: BoxDecoration(
  //                       border: Border.all(color: Colors.green, width: 2),
  //                       color: Colors.green),
  //                   child: Text('Show Details')),
  //             ),
  //             Container(
  //                 margin: EdgeInsets.all(5),
  //                 padding: EdgeInsets.all(5),
  //                 decoration: BoxDecoration(
  //                     border: Border.all(color: Colors.green, width: 2),
  //                     color: Colors.green),
  //                 child: Text('Delete')),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget listingCard(double width, dynamic listing) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(255, 242, 242, 1),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ]),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Title: ${listing['title']}',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Text(
            'Company Name: ${listing['businessName']}',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 0.75)),
          ),
          Text(
            'Required Qty: ${'${listing['requiredQuantity']} ' + listing['unit']}',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 0.75)),
          ),
          Text(
            'Price Offered: ${listing['maxPrice'].toString()}',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 0.75)),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                listing['location'],
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Color.fromRGBO(0, 0, 0, 0.75)),
              ),
              GestureDetector(
                onTap: () {
                  NavigationHelper.push(
                      context,
                      EditListing(
                        listing: listing,
                      ));
                },
                child: Text(
                  'Edit>',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Color.fromRGBO(107, 142, 35, 1)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showListingDetails(BuildContext context, dynamic listing) {
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request Id: #${listing["requestId"].toString()}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Title: ${listing["title"]}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text('Business Name: : ${listing["businessName"].toString()}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                Text(
                  ' click for Info',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(48, 1, 255, 0.75),
                  ),
                ),
                Text('Description: ${listing["description"]}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                Text('Category: ${listing["category"]}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                Text(
                    'Required QTY: ${listing["requiredQuantity"].toString()}, ${listing["unit"]}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                Text('Price Offered: ₹ ${listing["maxPrice"].toString()}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                Text('Location:  ${listing["location"]}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                SizedBox(height: 10),
                Text('Created at:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                Text(
                    DateFormat("d MMMM y, h:mm a")
                        .format(DateTime.parse(listing["createdAt"])),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Connect with Buyer',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(107, 142, 35, 1)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color.fromRGBO(107, 142, 35, 1), width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by crop, quantity, location",
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(
            Icons.search,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget availableProduceListing(
    double width,
    dynamic listing,
  ) {
    return Container(
      width: width * 0.5,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            child: Image.network(
              listing['imageUrl'],
              fit: BoxFit.cover,
              height: 100,
              width: width,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/app_icon.png',
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Text(listing['title'],
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Text('Price: ₹ ${listing['price'].toString()}',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Text(
                'Quantity: ${listing['quantity'].toString()} ${listing['unit']}',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Text('Farmer: ${listing['farmerName']}',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
            ),
            child: Text(listing['location'],
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
          ),
          Container(
            width: width,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              color: Color.fromRGBO(107, 112, 92, 1),
            ),
            child: Center(
              child: Text(
                'Request to Buy',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
