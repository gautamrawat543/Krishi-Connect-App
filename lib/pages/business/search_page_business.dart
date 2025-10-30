import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:krishi_connect_app/services/api/api_service.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPageBusiness extends StatefulWidget {
  const SearchPageBusiness({super.key});

  @override
  State<SearchPageBusiness> createState() => _SearchPageBusinessState();
}

class _SearchPageBusinessState extends State<SearchPageBusiness> {
  List<Map<String, dynamic>> farmers = [];
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> filteredFarmerListings = [];
  bool isLoadingFilteredFarmerListings = false;

  Future<void> filterBuyerListings() async {
    setState(() {
      isLoadingFilteredFarmerListings = true;
    });
    try {
      final token = SharedPrefHelper.getToken();
      final listing = await service.searchFarmerListing(
          token: token, query: searchController.text);
      setState(() {
        // Ensure the UI updates after data fetch
        filteredFarmerListings = listing;
        isLoadingFilteredFarmerListings = false;
        print(filteredFarmerListings);
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoadingFilteredFarmerListings = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // fetchFarmers();
    loadBuyerListings();
    searchController.addListener(() {
      final query = searchController.text.trim();

      if (query.isEmpty) {
        setState(() {
          filteredFarmerListings = [];
        });
      } else if (query.length >= 3) {
        filterBuyerListings();
      }
    });
  }

  ApiService service = ApiService();

  Future<void> fetchFarmers() async {
    final token = SharedPrefHelper.getToken();

    final result = await service.getUserByRole(token: token, role: "FARMER");

    setState(() {
      farmers = result;
      isLoading = false;
    });
  }

  List<dynamic> FarmerListings = [];
  bool isLoadingFarmerListings = true;

  Future<void> loadBuyerListings() async {
    try {
      final token = SharedPrefHelper.getToken();
      final listing = await service.getFarmerListing(token: token);
      setState(() {
        // Ensure the UI updates after data fetch
        FarmerListings = listing;
        isLoadingFarmerListings = false;
        print(FarmerListings);
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoadingFarmerListings = false;
      });
    }
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
                  child: isLoadingFilteredFarmerListings ||
                          isLoadingFarmerListings
                      ? const Center(child: CircularProgressIndicator())
                      : (searchController.text.trim().length >= 3)
                          ? filteredFarmerListings.isEmpty
                              ? Center(
                                  child: Text(AppLocalizations.of(context)!
                                      .noMatchingListing))
                              : ListView.builder(
                                  itemCount: filteredFarmerListings.length,
                                  itemBuilder: (context, index) {
                                    return farmerListingCard(
                                        width, filteredFarmerListings[index]);
                                  },
                                )
                          : FarmerListings.isEmpty
                              ? const Center(
                                  child: Text('No Farmers Listings Found'))
                              : ListView.builder(
                                  itemCount: FarmerListings.length,
                                  itemBuilder: (context, index) {
                                    return farmerListingCard(
                                        width, FarmerListings[index]);
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
                  'Request Id: #${listing["listingId"].toString()}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Text(
                  '${listing["category"]}: ${listing["title"]}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(
                    '${AppLocalizations.of(context)!.farmer}: ${listing["farmerName"].toString()}',
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
                const SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
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
                      'Connect with Farmer',
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

  Widget searchCard(dynamic farmer) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Row(
        children: [
          Container(
            height: 90,
            margin: const EdgeInsets.only(right: 10),
            child: Image.asset(
              'assets/app_icon.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Name:\t',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    farmer['name'],
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Number:\t',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    farmer['phone'],
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'State:\t',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    farmer['location'],
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Text(
              //       'Crop:\t',
              //       style: TextStyle(
              //         fontSize: 15,
              //       ),
              //     ),
              //     Text(
              //       farmer.crop,
              //       style: TextStyle(
              //         fontSize: 15,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
