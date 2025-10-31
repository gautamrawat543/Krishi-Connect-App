import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:krishi_connect_app/services/api/api_service.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FarmerBuyerListing extends StatefulWidget {
  const FarmerBuyerListing({super.key, required this.listing});

  final dynamic listing;

  @override
  State<FarmerBuyerListing> createState() => _FarmerBuyerListingState();
}

class _FarmerBuyerListingState extends State<FarmerBuyerListing> {
  ApiService service = ApiService();

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
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: SingleChildScrollView(
          child: widget.listing.isEmpty
              ? const Center(child: Text('No listings found'))
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(AppLocalizations.of(context)!.buyerListings,
                        style: AppTextStyles.pageHeading),
                    const SizedBox(height: 6),
                    const Divider(
                        thickness: 2, color: AppColors.primaryGreenDark),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: height * 0.7,
                      child: ListView.builder(
                        itemCount: widget.listing.length,
                        itemBuilder: (context, index) {
                          return listingCard(width, widget.listing[index]);
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget listingCard(double width, dynamic listing) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: cardBoxDecoration,
      width: width,
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
              '${AppLocalizations.of(context)!.priceOffered}: ₹ ${listing['maxPrice']}',
              style: AppTextStyles.cardSubText),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(listing['location'], style: AppTextStyles.smallLabel),
              GestureDetector(
                onTap: () => showListingDetails(context, listing),
                child: Text('${AppLocalizations.of(context)!.about}>',
                    style: AppTextStyles.linkStyle),
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${AppLocalizations.of(context)!.requestId}: #${listing["requestId"]}',
                    style: AppTextStyles.modalLabel),
                Text(
                    '${AppLocalizations.of(context)!.title}: ${listing["title"]}',
                    style: AppTextStyles.modalTitle),
                Text(
                    '${AppLocalizations.of(context)!.businessName}: ${listing["businessName"]}',
                    style: AppTextStyles.modalLabel),
                Text(
                    '${AppLocalizations.of(context)!.description}: ${listing["description"]}',
                    style: AppTextStyles.modalLabel),
                Text(
                    '${AppLocalizations.of(context)!.category}: ${listing["category"]}',
                    style: AppTextStyles.modalLabel),
                Text(
                  '${AppLocalizations.of(context)!.requiredQuantity}: ${listing["requiredQuantity"]} ${listing["unit"]}',
                  style: AppTextStyles.modalLabel,
                ),
                Text(
                    '${AppLocalizations.of(context)!.priceOffered}: ₹ ${listing["maxPrice"]}',
                    style: AppTextStyles.modalLabel),
                Text(
                    '${AppLocalizations.of(context)!.location}: ${listing["location"]}',
                    style: AppTextStyles.modalLabel),
                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await service.startConversation(
                            senderId: int.parse(SharedPrefHelper.getUserId()),
                            receiverId: listing["businessId"],
                            token: SharedPrefHelper.getToken(),
                            buyerRequestId: listing["requestId"]);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Successfully connected with Buyer'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
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
