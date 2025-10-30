import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishi_connect_app/services/api/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class SearchPageFarmer extends StatefulWidget {
  const SearchPageFarmer({super.key});

  @override
  State<SearchPageFarmer> createState() => _SearchPageFarmerState();
}

class _SearchPageFarmerState extends State<SearchPageFarmer> {
  List<Map<String, dynamic>> business = [];
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> filteredBuyerListings = [];
  bool isLoadingFilteredBuyerListings = false;

  Future<void> filterBuyerListings() async {
    setState(() {
      isLoadingFilteredBuyerListings = true;
    });
    try {
      final token = SharedPrefHelper.getToken();
      final listing = await service.searchBuyerListing(
          token: token, query: searchController.text);
      setState(() {
        // Ensure the UI updates after data fetch
        filteredBuyerListings = listing;
        isLoadingFilteredBuyerListings = false;
        print(filteredBuyerListings);
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoadingFilteredBuyerListings = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // fetchBusiness();
    loadBuyerListings();
    searchController.addListener(() {
      final query = searchController.text.trim();

      if (query.isEmpty) {
        setState(() {
          filteredBuyerListings = [];
        });
      } else if (query.length >= 3) {
        filterBuyerListings();
      }
    });
  }

  ApiService service = ApiService();

  List<dynamic> buyerListings = [];
  bool isLoadingBuyerListings = true;

  Future<void> loadBuyerListings() async {
    try {
      final token = SharedPrefHelper.getToken();
      final listing = await service.getBuyerRequest(token: token);
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

  Future<void> fetchBusiness() async {
    final token = SharedPrefHelper.getToken();

    final result = await service.getUserByRole(token: token, role: "BUSINESS");

    setState(() {
      business = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Search',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                searchBox(),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: height * 0.7,
                  child: isLoadingFilteredBuyerListings ||
                          isLoadingBuyerListings
                      ? const Center(child: CircularProgressIndicator())
                      : (searchController.text.trim().length >= 3)
                          ? filteredBuyerListings.isEmpty
                              ? Center(
                                  child: Text(AppLocalizations.of(context)!
                                      .noMatchingListing))
                              : ListView.builder(
                                  itemCount: filteredBuyerListings.length,
                                  itemBuilder: (context, index) {
                                    return farmerListingCard(
                                        width, filteredBuyerListings[index]);
                                  },
                                )
                          : buyerListings.isEmpty
                              ? Center(
                                  child: Text(AppLocalizations.of(context)!
                                      .noListingsFound))
                              : ListView.builder(
                                  itemCount: buyerListings.length,
                                  itemBuilder: (context, index) {
                                    return farmerListingCard(
                                        width, buyerListings[index]);
                                  },
                                ),
                ),
              ],
            ),
          ),
        ),
      ),
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
            '${AppLocalizations.of(context)!.businessName} : ${listing["businessName"].toString()}',
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 0.75)),
          ),
          Text(
            '${AppLocalizations.of(context)!.description}: ${listing['description']}',
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 0.75)),
          ),
          Text(
            '${AppLocalizations.of(context)!.requiredQuantity}: ${'${listing['requiredQuantity']} ' + listing['unit']}',
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Color.fromRGBO(0, 0, 0, 0.75)),
          ),
          Text(
            '${AppLocalizations.of(context)!.priceOffered}: ${listing['maxPrice'].toString()}',
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
                  AppLocalizations.of(context)!.about,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Color.fromRGBO(107, 142, 35, 1),
                  ),
                ),
              ),
            ],
          ),
        ],
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
                  'Request Id: #${listing["requestId"].toString()}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${listing["category"]}: ${listing["title"]}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                    '${AppLocalizations.of(context)!.businessName} : ${listing["businessName"].toString()}',
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
                    '${AppLocalizations.of(context)!.requiredQuantity}: ${listing["requiredQuantity"].toString()}, ${listing["unit"]}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(0, 0, 0, 0.75))),
                Text(
                    '${AppLocalizations.of(context)!.priceOffered}: ₹ ${listing["maxPrice"].toString()}',
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
                        backgroundColor: const Color.fromRGBO(107, 142, 35, 1)),
                    child: Text(
                      'Connect with Buyer',
                      style: TextStyle(color: Colors.white),
                    ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: const Color.fromRGBO(107, 142, 35, 1), width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchByCrop,
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (searchController.text.trim().length > 2) {
                filterBuyerListings();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please enter atleast 3 characters')));
              }
            },
            child: const Icon(
              Icons.search,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
