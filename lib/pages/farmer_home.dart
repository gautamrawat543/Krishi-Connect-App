import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:krishi_connect_app/pages/buyer_listing.dart';
import 'package:krishi_connect_app/pages/farmer_buyer_listing.dart';
import 'package:krishi_connect_app/pages/farmer_listing.dart';
import 'package:krishi_connect_app/services/api/news_api.dart';
import 'package:krishi_connect_app/data/company_listing.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';
import 'package:krishi_connect_app/utils/navigation_helper.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class FarmerHome extends StatefulWidget {
  const FarmerHome({super.key});

  @override
  State<FarmerHome> createState() => _FarmerHomeState();
}

class _FarmerHomeState extends State<FarmerHome> {
  List<dynamic> newsArticles = [];
  List<dynamic> companyListings = [];
  bool isCompanyLoading = false;

  bool isLoading = false;
  int page = 1; // Track page number for pagination

  @override
  void initState() {
    super.initState();
    loadNews();
    loadCompanyListings();
    loadBuyerListings();
  }

  List<dynamic> buyerListings = [];
  bool isLoadingBuyerListings = true;
  RegisterService service = RegisterService();

  Future<void> loadBuyerListings() async {
    try {
      final listing = await service.getFarmerListingById(
          token: SharedPrefHelper.getToken(),
          farmerId: SharedPrefHelper.getUserId());
      setState(() {
        // Ensure the UI updates after data fetch
        buyerListings = listing;
        isLoadingBuyerListings = false;
        print(buyerListings);
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoadingBuyerListings = false;
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
          leading: Icon(
            Icons.menu,
            color: Colors.white,
          ),
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
                        sectionHeader('Buyer Listings', onTap: () {
                          NavigationHelper.push(
                            context,
                            FarmerBuyerListing(listing: companyListings),
                          );
                        }),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                            thickness: 2, color: AppColors.primaryGreenDark),
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: companyListings.isEmpty
                              ? height * 0.2
                              : height * 0.35,
                          child: isCompanyLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.green),
                                )
                              : companyListings.isEmpty
                                  ? Center(
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
                        SizedBox(
                          height: 20,
                        ),
                        sectionHeader('Explore more about Farming'),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                            thickness: 2, color: AppColors.primaryGreenDark),
                        SizedBox(
                          height: 8,
                        ),
                        newsCard(height, width),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Create a Listing',
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(0, 0, 0, 0.75)),
                            ),
                            GestureDetector(
                              onTap: () => NavigationHelper.push(
                                  context, FarmerListing()),
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
                              // onTap: () {
                              //   NavigationHelper.push(
                              //       context,
                              //       BuyerListing(
                              //         companyListings: companyListings,
                              //       ));
                              // },
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
                        Divider(
                            thickness: 2,
                            color: Color.fromRGBO(107, 142, 35, 1)),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: height * 0.5,
                          child: isLoadingBuyerListings
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.green))
                              : buyerListings.isEmpty
                                  ? Center(
                                      child: Text('No Listings Found'),
                                    )
                                  : ListView.builder(
                                      itemCount: buyerListings.length > 5
                                          ? 5
                                          : buyerListings.length,
                                      itemBuilder: (context, index) {
                                        return farmerListingCard(
                                          width,
                                          buyerListings[index],
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
                onTap: () => showListingDetails(context, listing),
                child: const Text('About>', style: AppTextStyles.linkStyle),
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
            child: const Text('See All>', style: AppTextStyles.linkStyle),
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
              Text('Request Id: #${listing["requestId"]}',
                  style: AppTextStyles.cardSubText),
              Text('Title: ${listing["title"]}',
                  style: AppTextStyles.modalTitle),
              Text('Business Name: ${listing["businessName"]}',
                  style: AppTextStyles.modalLabel),
              const Text(' click for Info', style: AppTextStyles.modalInfoLink),
              Text('Description: ${listing["description"]}',
                  style: AppTextStyles.modalLabel),
              Text('Category: ${listing["category"]}',
                  style: AppTextStyles.modalLabel),
              Text(
                  'Required QTY: ${listing["requiredQuantity"]}, ${listing["unit"]}',
                  style: AppTextStyles.modalLabel),
              Text('Price Offered: ₹ ${listing["maxPrice"]}',
                  style: AppTextStyles.modalLabel),
              Text('Location:  ${listing["location"]}',
                  style: AppTextStyles.modalLabel),
              const SizedBox(height: 10),
              const Text('Created at:', style: AppTextStyles.modalLabel),
              Text(
                  DateFormat("d MMMM y, h:mm a")
                      .format(DateTime.parse(listing["createdAt"])),
                  style: AppTextStyles.modalLabel),
              const SizedBox(height: 25),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {},
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
                  'Request Id: #${listing["listingId"].toString()}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${listing["category"]}: ${listing["title"]}',
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
                    'Quantity: ${listing["quantity"].toString()}, ${listing["unit"]}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                Text('Price Offered: ₹ ${listing["price"].toString()}',
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

  Widget farmerListingCard(double width, dynamic listing) {
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
            '${listing['category']}: ${listing['title']}',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Text(
            'Description: ${listing['description']}',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 0.75)),
          ),
          Text(
            'Required Qty: ${'${listing['quantity']} ' + listing['unit']}',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 0.75)),
          ),
          Text(
            'Price Offered: ${listing['price'].toString()}',
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
                  showFarmerListingDetails(context, listing);
                },
                child: Text(
                  'About>',
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
