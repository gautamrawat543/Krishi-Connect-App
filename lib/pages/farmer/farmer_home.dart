import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:krishi_connect_app/pages/business/buyer_listing.dart';
import 'package:krishi_connect_app/pages/farmer/farmer_buyer_listing.dart';
import 'package:krishi_connect_app/pages/farmer/farmer_listing.dart';
import 'package:krishi_connect_app/services/api/news_api.dart';
import 'package:krishi_connect_app/services/api/api_service.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';
import 'package:krishi_connect_app/utils/navigation_helper.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FarmerHome extends StatefulWidget {
  const FarmerHome({super.key});

  @override
  State<FarmerHome> createState() => _FarmerHomeState();
}

class _FarmerHomeState extends State<FarmerHome> {
  List<dynamic> newsArticles = [];
  List<dynamic> companyListings = [];
  bool isCompanyLoading = false;
  bool isConnected = false;

  bool isLoading = false;
  int page = 1; // Track page number for pagination

  @override
  void initState() {
    super.initState();
    loadNews();
    loadCompanyListings();
    loadFarmerListings();
  }

  List<dynamic> farmerListings = [];
  bool isLoadingFarmerListings = true;
  ApiService service = ApiService();

  Future<void> loadFarmerListings() async {
    try {
      final listing = await service.getFarmerListingById(
          token: SharedPrefHelper.getToken(),
          farmerId: SharedPrefHelper.getUserId());
      setState(() {
        // Ensure the UI updates after data fetch
        farmerListings = listing;
        isLoadingFarmerListings = false;
        print(farmerListings);
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoadingFarmerListings = false;
      });
    }
  }

  Future<void> loadCompanyListings() async {
    setState(() {
      isCompanyLoading = true;
    });
    try {
      final listings =
          await service.getBuyerRequest(token: SharedPrefHelper.getToken());
      setState(() {
        // Ensure the UI updates after data fetch
        companyListings = listings;
        isCompanyLoading = false;
        print(companyListings);
      });
    } catch (e) {
      print(e);
      setState(() {
        isCompanyLoading = false;
      });
    }
  }

  Future<void> loadNews() async {
    setState(() {
      isLoading = true;
    });

    try {
      final articles = await NewsService.fetchNews(page);
      setState(() {
        newsArticles
            .addAll(articles); // Add the new articles to the existing list
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
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
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            // Trigger load more when the user reaches the bottom
            if (!isLoading &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              setState(() {
                page++; // Increment the page number
              });
              loadNews(); // Fetch next page of news
              return true;
            }
            return false;
          },
          child: isLoading && newsArticles.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                )
              : SingleChildScrollView(
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
                        sectionHeader(
                          AppLocalizations.of(context)!.buyerListings,
                          onTap: () {
                            NavigationHelper.push(
                              context,
                              FarmerBuyerListing(listing: companyListings),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Divider(
                            thickness: 2, color: AppColors.primaryGreenDark),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: companyListings.isEmpty
                              ? height * 0.2
                              : height * 0.35,
                          child: isCompanyLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.green),
                                )
                              : companyListings.isEmpty
                                  ? const Center(
                                      child: Text(
                                          'No buyer listings available right now.',
                                          style: AppTextStyles.noDataText))
                                  : ListView.builder(
                                      itemCount: companyListings.length > 5
                                          ? 5
                                          : companyListings.length,
                                      itemBuilder: (context, index) {
                                        return listingCard(
                                            width, companyListings[index]);
                                      },
                                    ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        sectionHeader(AppLocalizations.of(context)!
                            .exploreMoreAboutFarming),
                        const SizedBox(
                          height: 6,
                        ),
                        const Divider(
                            thickness: 2, color: AppColors.primaryGreenDark),
                        const SizedBox(
                          height: 8,
                        ),
                        newsCard(height, width),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.createAListing,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(0, 0, 0, 0.75),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => NavigationHelper.push(
                                  context, FarmerListing()),
                              child: const Icon(
                                Icons.add_circle_outline_rounded,
                                color: Color.fromRGBO(0, 0, 0, 0.75),
                                size: 45,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          AppLocalizations.of(context)!.myListings,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Divider(
                            thickness: 2,
                            color: Color.fromRGBO(107, 142, 35, 1)),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: height * 0.5,
                          child: isLoadingFarmerListings
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.green))
                              : farmerListings.isEmpty
                                  ? Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .noListingsFound,
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: farmerListings.length,
                                      itemBuilder: (context, index) {
                                        return farmerListingCard(
                                          width,
                                          farmerListings[index],
                                        );
                                      }),
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }

  // Function to open the article URL in a browser
  void launchURL(String url) {
    // Use url_launcher package
    launch(url);
  }

  Widget newsCard(double height, double width) {
    return SizedBox(
      height: height * 0.3,
      width: width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: newsArticles.length,
        itemBuilder: (context, index) {
          final article = newsArticles[index];
          return GestureDetector(
            onTap: () => launchURL(article['url']),
            child: Container(
              width: width * 0.8,
              margin: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article['urlToImage'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        article['urlToImage'],
                        height: height * 0.2,
                        width: width,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: height * 0.2,
                          width: width,
                          color: Colors.grey[300],
                          child:
                              Icon(Icons.broken_image, color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(article['title'] ?? '',
                      style: AppTextStyles.cardTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(article['description'] ?? '',
                      style: AppTextStyles.cardSubText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          );
        },
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
              '${AppLocalizations.of(context)!.priceOffered}: ${listing['maxPrice']}',
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

  Widget sectionHeader(String title, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.pageHeading),
        if (onTap != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              AppLocalizations.of(context)!.seeAll,
              style: AppTextStyles.linkStyle,
            ),
          ),
      ],
    );
  }

  void showListingDetails(BuildContext context, dynamic listing) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${AppLocalizations.of(context)!.requestId}: #${listing["requestId"]}',
                  style: AppTextStyles.cardSubText),
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
                  '${AppLocalizations.of(context)!.requiredQuantity}: ${listing["requiredQuantity"]}, ${listing["unit"]}',
                  style: AppTextStyles.modalLabel),
              Text(
                  '${AppLocalizations.of(context)!.priceOffered}: ₹ ${listing["maxPrice"]}',
                  style: AppTextStyles.modalLabel),
              Text(
                  '${AppLocalizations.of(context)!.location}:  ${listing["location"]}',
                  style: AppTextStyles.modalLabel),
              const SizedBox(height: 10),
              Text('${AppLocalizations.of(context)!.createdAt}:',
                  style: AppTextStyles.modalLabel),
              Text(
                  DateFormat("d MMMM y, h:mm a")
                      .format(DateTime.parse(listing["createdAt"])),
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
                      backgroundColor: AppColors.primaryGreenDark),
                  child: const Text('Connect with Buyer',
                      style: AppTextStyles.buttonTextStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showFarmerListingDetails(BuildContext context, dynamic listing) {
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.requestId}: #${listing["listingId"].toString()}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${listing["category"]}: ${listing["title"]}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                    '${AppLocalizations.of(context)!.businessName}: : ${listing["businessName"].toString()}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                Text(
                    '${AppLocalizations.of(context)!.description}: ${listing["description"]}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                Text(
                    '${AppLocalizations.of(context)!.category}: ${listing["category"]}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                Text(
                    '${AppLocalizations.of(context)!.requiredQuantity}: ${listing["quantity"].toString()}, ${listing["unit"]}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                Text(
                    '${AppLocalizations.of(context)!.priceOffered}: ₹ ${listing["price"].toString()}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                Text(
                    '${AppLocalizations.of(context)!.location}:  ${listing["location"]}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                const SizedBox(height: 10),
                Text('${AppLocalizations.of(context)!.createdAt}:',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                Text(
                    DateFormat("d MMMM y, h:mm a")
                        .format(DateTime.parse(listing["createdAt"])),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget farmerListingCard(double width, dynamic listing) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(255, 242, 242, 1),
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
            '${listing['category']}: ${listing['title']}',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Text(
            '${AppLocalizations.of(context)!.description}: ${listing['description']}',
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 0.75)),
          ),
          Text(
            '${AppLocalizations.of(context)!.requiredQuantity}: ${'${listing['quantity']} ' + listing['unit']}',
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 0.75)),
          ),
          Text(
            '${AppLocalizations.of(context)!.priceOffered}: ${listing['price'].toString()}',
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 0.75)),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                listing['location'],
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Color.fromRGBO(0, 0, 0, 0.75)),
              ),
              GestureDetector(
                onTap: () {
                  showFarmerListingDetails(context, listing);
                },
                child: Text(
                  '${AppLocalizations.of(context)!.about}>',
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
}
