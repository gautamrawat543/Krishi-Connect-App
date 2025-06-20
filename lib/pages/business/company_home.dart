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
import 'package:krishi_connect_app/pages/business/search_page_business.dart';
import 'package:krishi_connect_app/services/api/api_service.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';
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

  ApiService service = ApiService();

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
        backgroundColor: AppColors.primaryGreenDark,
        leading: const Icon(Icons.menu, color: Colors.white),
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
                style: AppTextStyles.welcomeHeading,
              ),
              SizedBox(
                height: 20,
              ),
              _sectionHeader('Available Produce'),
              SizedBox(
                height: 6,
              ),
              const Divider(thickness: 2, color: AppColors.primaryGreenDark),
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
                      child: _availableProduceListing(
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
              _titleRow('Create a Request', Icons.add_circle_outline_rounded,
                  () {
                NavigationHelper.push(context, const CreateListing());
              }),
              SizedBox(
                height: 25,
              ),
              _sectionHeader('My Listings', showAll: true, onTap: () {
                NavigationHelper.push(
                  context,
                  BuyerListing(companyListings: companyListings),
                );
              }),
              SizedBox(
                height: 6,
              ),
              const Divider(thickness: 2, color: AppColors.primaryGreenDark),
              SizedBox(
                height: 16,
              ),
              _filterChips(),
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
                              return _listingCard(
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

  Widget _availableProduceListing(
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

  Widget _sectionHeader(String title,
      {bool showAll = false, VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.pageHeading),
        if (showAll)
          GestureDetector(
            onTap: onTap,
            child: const Text('See All>', style: AppTextStyles.linkStyle),
          ),
      ],
    );
  }

  Widget _titleRow(String title, IconData icon, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.pageHeading.copyWith(fontSize: 28)),
        GestureDetector(
          onTap: onTap,
          child: Icon(icon, color: AppColors.labelColor, size: 45),
        ),
      ],
    );
  }

  Widget _filterChips() {
    List<String> filters = ['All', 'Open', 'Closed'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: filters.map((filter) {
        bool selected = isSelected == filter;
        return GestureDetector(
          onTap: () => setState(() => isSelected = filter),
          child: Container(
            width: 80,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: selected
                  ? Colors.black.withOpacity(0.75)
                  : Colors.black.withOpacity(0.3),
            ),
            child: Center(
              child: Text(
                filter,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _listingCard(double width, dynamic listing) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: cardBoxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Title: ${listing['title']}', style: AppTextStyles.cardTitle),
          Text('Company Name: ${listing['businessName']}',
              style: AppTextStyles.cardSubText),
          Text(
              'Required Qty: ${listing['requiredQuantity']} ${listing['unit']}',
              style: AppTextStyles.cardSubText),
          Text('Price Offered: ${listing['maxPrice']}',
              style: AppTextStyles.cardSubText),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(listing['location'], style: AppTextStyles.smallLabel),
              GestureDetector(
                onTap: () {
                  NavigationHelper.push(context, EditListing(listing: listing));
                },
                child: const Text('Edit>', style: AppTextStyles.linkStyle),
              ),
            ],
          )
        ],
      ),
    );
  }
}
