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
          backgroundColor: Color.fromRGBO(107, 142, 35, 1),
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
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        searchBox(),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Buyer Listings',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                NavigationHelper.push(
                                    context,
                                    FarmerBuyerListing(
                                      listing: companyListings,
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
                        Divider(
                            thickness: 2,
                            color: Color.fromRGBO(107, 142, 35, 1)),
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
                                          'No buyer listings available right now.'),
                                    )
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Explore more about Farming ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // Text(
                            //   'See All>',
                            //   style: TextStyle(
                            //       fontSize: 12,
                            //       fontWeight: FontWeight.w400,
                            //       color: Color.fromRGBO(107, 142, 35, 1)),
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                            thickness: 2,
                            color: Color.fromRGBO(107, 142, 35, 1)),
                        SizedBox(
                          height: 8,
                        ),
                        newsCard(height, width),
                        SizedBox(
                          height: 40,
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
              onTap: () {
                // Open the article URL
                launchURL(article['url']);
              },
              child: Container(
                width: width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article['urlToImage'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        child: Image.network(
                          article['urlToImage'] ?? '',
                          height: height * 0.2,
                          width: width,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: height * 0.2,
                              width: width,
                              color: Colors.grey[300], // Placeholder background
                              child: Icon(Icons.broken_image,
                                  color: Colors.grey[600]), // Error icon
                            );
                          },
                        ),
                      ),
                    SizedBox(height: 10),
                    Text(
                      article['title'] ?? '',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      article['description'] ?? '',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(0, 0, 0, 0.5)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

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
                  showListingDetails(context, listing);
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
                    onPressed: () async {
                      await service.startConversation(
                          senderId: int.parse(SharedPrefHelper.getUserId()),
                          receiverId: listing['businessId'],
                          buyerRequestId: listing['requestId'],
                          token: SharedPrefHelper.getToken());
                    },
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
                hintText: "What are you growing today?",
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
