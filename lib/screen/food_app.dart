import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:seafood_app/screen/chatborad.dart';
import 'package:seafood_app/screen/food_oderpage.dart';
import 'package:seafood_app/screen/profile/profile.dart';
import 'package:seafood_app/screen/support_page.dart';
import 'mainhome_page.dart';

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seafood Main',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class MainScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  final _pageOptions = [
    HomePage(),
    FoodOrderPage(
      initialCartItems: [],
    ),
    ChatBoardPage(),
    SupportPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blue,
        // ignore: prefer_const_literals_to_create_immutables
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.restaurant_menu, size: 30),
          Icon(Icons.chat, size: 30),
          Icon(Icons.support_agent, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}
