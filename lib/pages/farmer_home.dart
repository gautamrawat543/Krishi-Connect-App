import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:krishi_connect_app/pages/buyer_listing.dart';
import 'package:krishi_connect_app/pages/farmer_buyer_listing.dart';
import 'package:krishi_connect_app/services/api/news_api.dart';
import 'package:krishi_connect_app/data/company_listing.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
import 'package:krishi_connect_app/utils/navigation_helper.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';
import 'package:krishi_connect_app/utils/app_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:krishi_connect_app/utils/common_search_box.dart';

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
  int page = 1;

  @override
  void initState() {
    super.initState();
    loadNews();
    loadCompanyListings();
  }

  RegisterService service = RegisterService();

  Future<void> loadCompanyListings() async {
    setState(() => isCompanyLoading = true);
    try {
      final listings = await service.getBuyerRequest(token: SharedPrefHelper.getToken());
      setState(() {
        companyListings = listings;
        isCompanyLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() => isCompanyLoading = false);
    }
  }

  Future<void> loadNews() async {
    setState(() => isLoading = true);
    try {
      final articles = await NewsService.fetchNews(page);
      setState(() {
        newsArticles.addAll(articles);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreenDark,
        leading: const Icon(Icons.menu, color: AppColors.white),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            setState(() => page++);
            loadNews();
            return true;
          }
          return false;
        },
        child: isLoading && newsArticles.isEmpty
            ? const Center(child: CircularProgressIndicator(color: Colors.green))
            : SingleChildScrollView(
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
                    searchBox(),
                    const SizedBox(height: 20),
                    sectionHeader('Buyer Listings', onTap: () {
                      NavigationHelper.push(
                        context,
                        FarmerBuyerListing(listing: companyListings),
                      );
                    }),
                   const Divider(thickness: 2, color: AppColors.primaryGreenDark),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: companyListings.isEmpty ? height * 0.2 : height * 0.35,
                      child: isCompanyLoading
                          ? const Center(child: CircularProgressIndicator(color: Colors.green))
                          : companyListings.isEmpty
                              ? const Center(child: Text('No buyer listings available right now.', style: AppTextStyles.noDataText))
                              : ListView.builder(
                                  itemCount: companyListings.length > 5 ? 5 : companyListings.length,
                                  itemBuilder: (context, index) => listingCard(width, companyListings[index]),
                                ),
                    ),
                    const SizedBox(height: 20),
                    sectionHeader('Explore more about Farming'),
                    const Divider(thickness: 2, color: AppColors.primaryGreenDark),
                    const SizedBox(height: 8),
                    newsCard(height, width),
                  ],
                ),
              ),
      ),
    );
  }

  void launchURL(String url) => launch(url);

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
                          child: Icon(Icons.broken_image, color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(article['title'] ?? '', style: AppTextStyles.cardTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(article['description'] ?? '', style: AppTextStyles.cardSubText, maxLines: 1, overflow: TextOverflow.ellipsis),
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
          Text('Company Name: ${listing['businessName']}', style: AppTextStyles.cardSubText),
          Text('Required Qty: ${listing['requiredQuantity']} ${listing['unit']}', style: AppTextStyles.cardSubText),
          Text('Price Offered: ${listing['maxPrice']}', style: AppTextStyles.cardSubText),
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

  void showListingDetails(BuildContext context, dynamic listing) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Request Id: #${listing["requestId"]}', style: AppTextStyles.cardSubText),
              Text('Title: ${listing["title"]}', style: AppTextStyles.modalTitle),
              Text('Business Name: ${listing["businessName"]}', style: AppTextStyles.modalLabel),
              const Text(' click for Info', style: AppTextStyles.modalInfoLink),
              Text('Description: ${listing["description"]}', style: AppTextStyles.modalLabel),
              Text('Category: ${listing["category"]}', style: AppTextStyles.modalLabel),
              Text('Required QTY: ${listing["requiredQuantity"]}, ${listing["unit"]}', style: AppTextStyles.modalLabel),
              Text('Price Offered: ₹ ${listing["maxPrice"]}', style: AppTextStyles.modalLabel),
              Text('Location:  ${listing["location"]}', style: AppTextStyles.modalLabel),
              const SizedBox(height: 10),
              const Text('Created at:', style: AppTextStyles.modalLabel),
              Text(DateFormat("d MMMM y, h:mm a").format(DateTime.parse(listing["createdAt"])), style: AppTextStyles.modalLabel),
              const SizedBox(height: 25),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreenDark),
                  child: const Text('Connect with Buyer', style: AppTextStyles.buttonTextStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBox() {
  return const CommonSearchBox(hintText: "What are you growing today?");
}

}
