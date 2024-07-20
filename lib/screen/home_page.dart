import 'package:flutter/material.dart';
import 'package:seafood_app/screen/home.dart';
import 'package:seafood_app/screen/profile.dart';
import 'recipes_page.dart';
import 'favorites_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('หน้าแรก'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.restaurant_menu),
              title: Text('ออเดอร์ของฉัน'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipesPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('สิ่งที่ถูกใจ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('โปรไฟล์'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('ออกจากระบบ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()), //แก้ให้กลับไปหน้าหลัก
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('เปิดร้านอาหาร'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.motorcycle),
              title: Text('สมัครไรเดอร์'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('???'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
        
      ),
    
      body: Center(
        child: Text('Home Page Content'),
      ),
    );
  }
}
