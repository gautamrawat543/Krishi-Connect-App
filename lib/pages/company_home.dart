import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishi_connect_app/data/produce_data.dart';
import 'package:krishi_connect_app/pages/buyer_listing.dart';
import 'package:krishi_connect_app/pages/create_listing.dart';
import 'package:krishi_connect_app/pages/edit_listing.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
import 'package:krishi_connect_app/utils/navigation_helper.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';
import 'package:krishi_connect_app/utils/common_search_box.dart';


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
  String isSelected = 'All';
  final RegisterService service = RegisterService();

  @override
  void initState() {
    super.initState();
    loadFarmers();
    loadCompanyListings();
  }

  Future<void> loadFarmers() async {
    try {
      final listings = await service.getFarmer(token: SharedPrefHelper.getToken());
      setState(() {
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
        businessId: SharedPrefHelper.getUserId(),
      );
      setState(() {
        companyListings = listing;
        isLoadingCompanyListings = false;
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreenDark,
        leading: const Icon(Icons.menu, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              'Welcome back\n${SharedPrefHelper.getUsername().toUpperCase()}!',
              style: AppTextStyles.welcomeHeading,
            ),
            const SizedBox(height: 20),
            _searchBox(),
            const SizedBox(height: 20),
            _sectionHeader('Available Produce'),
            const Divider(thickness: 2, color: AppColors.primaryGreenDark),
            const SizedBox(height: 8),
            SizedBox(
              height: height * 0.4,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: produceList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _availableProduceListing(width, produceList[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            _titleRow('Create a Request', Icons.add_circle_outline_rounded, () {
              NavigationHelper.push(context, const CreateListing());
            }),
            const SizedBox(height: 25),
            _sectionHeader('My Listings', showAll: true, onTap: () {
              NavigationHelper.push(
                context,
                BuyerListing(companyListings: companyListings),
              );
            }),
            const Divider(thickness: 2, color: AppColors.primaryGreenDark),
            const SizedBox(height: 16),
            _filterChips(),
            const SizedBox(height: 15),
            SizedBox(
              height: height * 0.5,
              child: isLoadingCompanyListings
                  ? const Center(child: CircularProgressIndicator(color: Colors.green))
                  : companyListings.isEmpty
                      ? const Center(child: Text('No Listings Found'))
                      : ListView.builder(
                          itemCount: companyListings.length > 5 ? 5 : companyListings.length,
                          itemBuilder: (context, index) => _listingCard(width, companyListings[index]),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, {bool showAll = false, VoidCallback? onTap}) {
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

  Widget _searchBox() {
  return const CommonSearchBox(hintText: "Search by crop, quantity, location");
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
              color: selected ? Colors.black.withOpacity(0.75) : Colors.black.withOpacity(0.3),
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

  Widget _availableProduceListing(double width, ProduceItem item) {
    return Container(
      width: width * 0.5,
      decoration: cardBoxDecoration.copyWith(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: Image.asset('assets/images/Banner.jpg', fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(item.name, style: AppTextStyles.cardTitle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text('Price: ₹ ${item.price}', style: AppTextStyles.cardSubText),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text('Available QTY: ${item.quantity}', style: AppTextStyles.cardSubText),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text('Farmer: ${item.farmer}', style: AppTextStyles.cardSubText),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(item.location, style: AppTextStyles.cardSubText),
          ),
          Container(
            width: width,
            height: 40,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(107, 112, 92, 1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: const Center(
              child: Text('Request to Buy', style: AppTextStyles.buttonTextStyle),
            ),
          ),
        ],
      ),
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
          Text('Company Name: ${listing['businessName']}', style: AppTextStyles.cardSubText),
          Text('Required Qty: ${listing['requiredQuantity']} ${listing['unit']}', style: AppTextStyles.cardSubText),
          Text('Price Offered: ${listing['maxPrice']}', style: AppTextStyles.cardSubText),
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
