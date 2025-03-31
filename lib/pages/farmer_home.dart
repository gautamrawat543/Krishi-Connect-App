import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:krishi_connect_app/services/api/news_api.dart';
import 'package:krishi_connect_app/data/company_listing.dart';
import 'package:krishi_connect_app/services/api/register_api.dart';
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
  bool isLoading = false;
  int page = 1; // Track page number for pagination

  @override
  void initState() {
    super.initState();
    loadNews();
    loadCompanyListings();
  }

  RegisterService service = RegisterService();
  Future<void> loadCompanyListings() async {
    try {
      final listings =
          await service.getBuyerRequest(token: SharedPrefHelper.getToken());
      setState(() {
        // Ensure the UI updates after data fetch
        companyListings = listings;
      });
    } catch (e) {
      print(e);
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
          backgroundColor: Colors.green,
          title: Text(
            'Hello ${SharedPrefHelper.getUsername().toUpperCase()}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
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
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5),
                          child: Text(
                            'News',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      newsCard(height, width),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5),
                          child: Text(
                            'Listings',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.3,
                        child: ListView.builder(
                            itemCount: companyListings.length,
                            itemBuilder: (context, index) {
                              return listingCard(width, companyListings[index]);
                            }),
                      ),
                    ],
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
      height: height * 0.46,
      width: width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: newsArticles.length,
          itemBuilder: (context, index) {
            final article = newsArticles[index];
            return Container(
              width: width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article['urlToImage'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
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
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Text(
                          'Title- ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                        Expanded(
                          child: Text(
                            article['title'] ?? '',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          'Description - ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900),
                        ),
                        Expanded(
                          child: Text(
                            article['description'] ?? '',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      article['publishedAt']?.substring(0, 10),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Open the article URL
                      launchURL(article['url']);
                    },
                    child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Text(
                          'Read More',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget listingCard(double width, dynamic listing) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
      ),
      width: width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'C.Name',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(listing["businessId"].toString(),
                      style: TextStyle(fontSize: 15)),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Product',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(listing["category"], style: TextStyle(fontSize: 15)),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Quantity',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                      listing["requiredQuantity"].toString() +
                          " " +
                          listing["unit"],
                      style: TextStyle(fontSize: 15)),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text('Accept'),
              ),
              GestureDetector(
                onTap: () => showListingDetails(context, listing),
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text('About'),
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text('Reject'),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Company: ${listing["businessId"].toString()}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Product: ${listing["category"]}',
                  style: TextStyle(fontSize: 16)),
              Text(
                  'Quantity: ${listing["requiredQuantity"].toString()} ${listing["unit"]}',
                  style: TextStyle(fontSize: 16)),
              Text('Price: ${listing["maxPrice"].toString()}',
                  style: TextStyle(fontSize: 16)),
              Text('Description: ${listing["description"]}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Connect with Buyer',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        );
      },
    );
  }
}
