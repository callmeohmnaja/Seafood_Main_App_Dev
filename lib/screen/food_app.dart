import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:seafood_app/screen/profile.dart';
import 'package:seafood_app/screen/raider_page.dart';
import 'mainhome_page.dart';
import 'oder.dart';
import 'favorites_page.dart';


class FoodApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seafood Main',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  final _pageOptions = [
    HomePage(),
    RecipesPage(),
    FavoritesPage(),
    ProfilePage(),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.greenAccent,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.restaurant_menu, size: 30),
          Icon(Icons.favorite, size: 30),
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
