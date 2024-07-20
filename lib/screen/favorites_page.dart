import 'package:flutter/material.dart';
import 'package:seafood_app/screen/mainhome_page.dart';
import 'package:seafood_app/screen/oder.dart';
import 'package:seafood_app/screen/profile.dart';
import 'package:seafood_app/screen/raider_page.dart';
import 'package:seafood_app/screen/store_page.dart';
import 'package:seafood_app/screen/support_page.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
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
                 Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()),
                );
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
              leading: Icon(Icons.motorcycle),
              title: Text('สมัครไรเดอร์'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RaiderPage()),
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
                  MaterialPageRoute(builder: (context) => StorePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.support),
              title: Text('แจ้งปัญหา'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Favorites Page Content'),
      ),
    );
  }
}
