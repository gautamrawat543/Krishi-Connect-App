import 'package:flutter/material.dart';
import 'package:krishi_connect_app/pages/common/chat_screen.dart';
import 'package:krishi_connect_app/pages/business/company_home.dart';
import 'package:krishi_connect_app/pages/farmer/farmer_home.dart';
import 'package:krishi_connect_app/pages/common/farmer_profile.dart';
import 'package:krishi_connect_app/pages/business/search_page_business.dart';
import 'package:krishi_connect_app/pages/farmer/search_page_farmer.dart';
import 'package:krishi_connect_app/utils/shared_pref_helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Default page is Home
  List<Widget> _pages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // List of pages to switch between
    _pages = SharedPrefHelper.getUserrole() == 'FARMER'
        ? [
            const FarmerHome(),
            const SearchPageFarmer(),
            const ChatScreen(),
            const FarmerProfile(),
          ]
        : [
            const CompanyHome(),
            const SearchPageBusiness(),
            const ChatScreen(),
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
        unselectedItemColor: Color.fromRGBO(107, 142, 35, 1),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_rounded),
            label: 'Message',
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
