import 'package:flutter/material.dart';
import 'package:seafood_app/BookGuide/howtopay_page.dart';
import 'package:seafood_app/BookGuide/howtouse_page.dart';
import 'package:seafood_app/BookGuide/oderguide_page.dart';
import 'package:seafood_app/BookGuide/ruleapp_page.dart';
import 'package:seafood_app/BookGuide/storeguide_page.dart';
import 'package:seafood_app/screen/food_oderpage.dart';
import 'package:seafood_app/screen/home.dart';
import 'package:seafood_app/screen/mainhome_page.dart';
import 'package:seafood_app/screen/profile.dart';
import 'package:seafood_app/screen/raider_page.dart';
import 'package:seafood_app/screen/store_page.dart';
import 'package:seafood_app/screen/support_page.dart';

// ignore: use_key_in_widget_constructors
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('คู่มือการใช้งาน'),
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
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
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
                  MaterialPageRoute(builder: (context) => FoodOrderPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('คู่มือการใช้งาน'),
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
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20), // Add padding around the container
        color: Colors.green[50], // Light background color for comfort
        child: ListView(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HowtousePage()), // Navigate to LoginScreen
                );
              },
              icon: Icon(Icons.info), // Add an icon
              label: Text("คู่มือการใช้งานเบื้องต้น"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15), // Increase vertical padding
                minimumSize: Size(double.infinity, 50), // Set fixed width and height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
              ),
            ),
            SizedBox(height: 10), // Spacing between buttons
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OderguidePage()), // Navigate to LoginScreen
                );
              },
              icon: Icon(Icons.food_bank),
              label: Text("คู่มือการสั่งอาหาร"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StoreguidePage()), // Navigate to LoginScreen
                );
              },
              icon: Icon(Icons.store_mall_directory),
              label: Text("คู่มือการเปิดร้านอาหาร"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HowtopayPage()), // Navigate to LoginScreen
                );
              },
              icon: Icon(Icons.payment),
              label: Text("ขั้นตอนการชําระเงิน"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RuleappPage()), // Navigate to LoginScreen
                );
              },
              icon: Icon(Icons.article),
              label: Text("ข้อตกลงของแอพพลิเคชัน"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
