import 'package:flutter/material.dart';
import 'package:krishi_connect_app/data/farmer_data.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedState = "All";
  String selectedCrop = "All";
  List<Farmer> filteredFarmers = [];

  @override
  void initState() {
    super.initState();
    filteredFarmers = farmers; // Initialize with all farmers
  }

  void filterFarmers() {
    setState(() {
      filteredFarmers = farmers.where((farmer) {
        bool matchesState =
            selectedState == "All" || farmer.state == selectedState;
        bool matchesCrop = selectedCrop == "All" || farmer.crop == selectedCrop;
        return matchesState && matchesCrop;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text("Select State"),
                  value: selectedState,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  dropdownColor: Colors.green,
                  icon: SizedBox.shrink(),
                  items: ["All", ...farmers.map((f) => f.state).toSet()]
                      .map((state) =>
                          DropdownMenuItem(value: state, child: Text(state)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedState = value!;
                      filterFarmers();
                    });
                  },
                ),
              ),
              const Text(
                'Search',
                style: TextStyle(color: Colors.white),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text("Select Crop"),
                  value: selectedCrop,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  dropdownColor: Colors.green,
                  icon: SizedBox.shrink(),
                  items: ["All", ...farmers.map((f) => f.crop).toSet()]
                      .map(
                        (crop) => DropdownMenuItem(
                          value: crop,
                          child: Text(crop),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCrop = value!;
                      filterFarmers();
                    });
                  },
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: [
            SizedBox(
              height: height * 0.8,
              child: filteredFarmers.isEmpty
                  ? Center(
                      child: Text('No Farmers Found'),
                    )
                  : ListView.builder(
                      itemCount: filteredFarmers.length,
                      itemBuilder: (context, index) {
                        return searchCard(filteredFarmers[index]);
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchCard(Farmer farmer) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Row(
        children: [
          Container(
            height: 90,
            margin: EdgeInsets.only(right: 10),
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
                  Text(
                    'Name:\t',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    farmer.name,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Number:\t',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    farmer.number,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'State:\t',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    farmer.state,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Crop:\t',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    farmer.crop,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
