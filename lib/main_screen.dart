import 'package:flutter/material.dart';
import 'package:krishi_connect_app/pages/company_home.dart';
import 'package:krishi_connect_app/pages/farmer_home.dart';
import 'package:krishi_connect_app/pages/farmer_profile.dart';
import 'package:krishi_connect_app/pages/search_page.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Default page is Home
  List<Widget> _pages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // List of pages to switch between
    _pages = SharedPrefHelper.getUserrole() == 'Farmer'
        ? [
            const SearchPage(),
            const FarmerHome(),
            const FarmerProfile(),
          ]
        : [
            const SearchPage(),
            const CompanyHome(),
            const FarmerProfile(),
          ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green, // Highlight selected tab
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
