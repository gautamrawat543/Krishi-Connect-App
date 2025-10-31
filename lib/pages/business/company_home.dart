import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:krishi_connect_app/pages/business/buyer_listing.dart';
import 'package:krishi_connect_app/pages/business/create_listing.dart';
import 'package:krishi_connect_app/pages/business/edit_listing.dart';
import 'package:krishi_connect_app/pages/business/search_page_business.dart';
import 'package:krishi_connect_app/services/api/api_service.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';
import 'package:krishi_connect_app/utils/navigation_helper.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  List<dynamic> filteredListings = [];
  bool isLoadingFilteredListings = true;

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
      print(produceListings);
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
        _applyFilter();
        isLoadingFilteredListings = false;
        isLoadingCompanyListings = false;
        print("companyListings : $companyListings");
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoadingCompanyListings = false;
      });
    }
  }

  void _applyFilter() {
    if (isSelected == 'All') {
      filteredListings = companyListings;
    } else {
      filteredListings = companyListings
          .where((listing) =>
              listing['status']?.toUpperCase() == isSelected.toUpperCase())
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreenDark,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                '${AppLocalizations.of(context)!.welcomeBack}\n${SharedPrefHelper.getUsername().toUpperCase()}!',
                style: AppTextStyles.welcomeHeading,
              ),
              const SizedBox(
                height: 20,
              ),
              _sectionHeader(AppLocalizations.of(context)!.availableProduce),

              const SizedBox(
                height: 6,
              ),
              const Divider(thickness: 2, color: AppColors.primaryGreenDark),
              const SizedBox(
                height: 8,
              ),
              //available produce listing
              produceListings.isEmpty
                  ? const Center(child: Text('No produce found'))
                  : SizedBox(
                      height: height * 0.28,
                      child: ListView.builder(
                        shrinkWrap: true,
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
              const SizedBox(
                height: 20,
              ),
              _titleRow(
                AppLocalizations.of(context)!.createARequest,
                Icons.add_circle_outline_rounded,
                () {
                  NavigationHelper.push(context, const CreateListing());
                },
              ),

              const SizedBox(
                height: 25,
              ),
              _sectionHeader(
                AppLocalizations.of(context)!.myListings,
                showAll: true,
                onTap: () {
                  NavigationHelper.push(
                    context,
                    BuyerListing(companyListings: companyListings),
                  );
                },
              ),

              const SizedBox(
                height: 6,
              ),
              const Divider(thickness: 2, color: AppColors.primaryGreenDark),
              const SizedBox(
                height: 16,
              ),
              _filterChips(),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: height * 0.5,
                child: isLoadingCompanyListings
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      )
                    : filteredListings.isEmpty
                        ? Center(
                            child: Text(
                              AppLocalizations.of(context)!.noListingsFound,
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredListings.length > 5
                                ? 5
                                : filteredListings.length,
                            itemBuilder: (context, index) {
                              return _listingCard(
                                width,
                                filteredListings[index],
                              );
                            },
                          ),
              )
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(
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
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Text(
                '${AppLocalizations.of(context)!.priceOffered}: ₹ ${listing['price'].toString()}',
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Text(
                '${AppLocalizations.of(context)!.requiredQuantity}: ${listing['quantity'].toString()} ${listing['unit']}',
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Text(
                '${AppLocalizations.of(context)!.farmer}: ${listing['farmerName']}',
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
            ),
            child: Text(listing['location'],
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
          ),
          GestureDetector(
            onTap: () async {
              try {
                await service.startConversation(
                    senderId: int.parse(SharedPrefHelper.getUserId()),
                    receiverId: listing["farmerId"],
                    token: SharedPrefHelper.getToken(),
                    listingId: listing["listingId"]);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully connected with Farmer'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Container(
              width: width,
              height: 40,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                color: Color.fromRGBO(107, 112, 92, 1),
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.startConversation,
                  style: const TextStyle(color: Colors.white),
                ),
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
          onTap: () {
            setState(() {
              isSelected = filter;
              _applyFilter();
            });
          },
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
          Text('${AppLocalizations.of(context)!.title}: ${listing['title']}',
              style: AppTextStyles.cardTitle),
          Text(
              '${AppLocalizations.of(context)!.businessName}: ${listing['businessName']}',
              style: AppTextStyles.cardSubText),
          Text(
              '${AppLocalizations.of(context)!.requiredQuantity}: ${listing['requiredQuantity']} ${listing['unit']}',
              style: AppTextStyles.cardSubText),
          Text(
              '${AppLocalizations.of(context)!.priceOffered}: ${listing['maxPrice']}',
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
                child: Text('${AppLocalizations.of(context)!.edit}>',
                    style: AppTextStyles.linkStyle),
              ),
            ],
          )
        ],
      ),
    );
  }
}
