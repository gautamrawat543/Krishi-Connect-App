import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishi_connect_app/pages/edit_listing.dart';
import 'package:krishi_connect_app/utils/navigation_helper.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';

class BuyerListing extends StatefulWidget {
  BuyerListing({super.key, required this.companyListings});

  List<dynamic> companyListings = [];

  @override
  State<BuyerListing> createState() => _BuyerListingState();
}

class _BuyerListingState extends State<BuyerListing> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreenDark,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppColors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text('Buyer Listings', style: AppTextStyles.pageHeading),
              const SizedBox(
                height: 6,
              ),
              const Divider(thickness: 2, color: AppColors.primaryGreenDark),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: searchBox()),
                  const Icon(
                    Icons.filter_list_alt,
                    color: AppColors.primaryGreenDark,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: height * 0.7,
                child: ListView.builder(
                  itemCount: widget.companyListings.length,
                  itemBuilder: (context, index) {
                    return listingCard(width, widget.companyListings[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryGreenDark, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "What are you growing today?",
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.search, color: AppColors.primaryGreen),
        ],
      ),
    );
  }

  Widget listingCard(double width, dynamic listing) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: cardBoxDecoration,
      width: width,
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
                  NavigationHelper.push(
                    context,
                    EditListing(listing: listing),
                  );
                },
                child: const Text('Edit>', style: AppTextStyles.linkStyle),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Request Id: #${listing["requestId"]}',
                    style: AppTextStyles.smallLabel),
                Text('Title: ${listing["title"]}',
                    style: AppTextStyles.modalTitle),
                Text('Business Name: ${listing["businessName"]}',
                    style: AppTextStyles.modalLabel),
                const Text(' click for Info',
                    style: AppTextStyles.modalInfoLink),
                Text('Description: ${listing["description"]}',
                    style: AppTextStyles.modalLabel),
                Text('Category: ${listing["category"]}',
                    style: AppTextStyles.modalLabel),
                Text(
                    'Required QTY: ${listing["requiredQuantity"]}, ${listing["unit"]}',
                    style: AppTextStyles.modalLabel),
                Text('Price Offered: ₹ ${listing["maxPrice"]}',
                    style: AppTextStyles.modalLabel),
                Text('Location: ${listing["location"]}',
                    style: AppTextStyles.modalLabel),
                const SizedBox(height: 10),
                const Text('Created at:', style: AppTextStyles.modalLabel),
                Text(
                  DateFormat("d MMMM y, h:mm a")
                      .format(DateTime.parse(listing["createdAt"])),
                  style: AppTextStyles.modalLabel,
                ),
                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreenDark,
                    ),
                    child: const Text('Connect with Buyer',
                        style: AppTextStyles.buttonTextStyle),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
