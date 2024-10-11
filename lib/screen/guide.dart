import 'package:flutter/material.dart';
import 'package:seafood_app/BookGuide/howtopay_page.dart';
import 'package:seafood_app/BookGuide/howtouse_page.dart';
import 'package:seafood_app/BookGuide/oderguide_page.dart';
import 'package:seafood_app/BookGuide/raider_guide_page.dart';
import 'package:seafood_app/BookGuide/ruleapp_page.dart';
import 'package:seafood_app/BookGuide/storeguide_page.dart';
import 'package:seafood_app/screen/food_app.dart';

// ignore: use_key_in_widget_constructors
class Guide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('คู่มือการใช้งาน'),
        backgroundColor: Colors.teal,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => FoodApp()));
        }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent], // สีพื้นหลังแบบไล่ระดับ
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HowtousePage()), // Navigate to How to use page
                );
              },
              icon: Icon(Icons.info),
              label: Text("คู่มือการใช้งานเบื้องต้น"),
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
                  MaterialPageRoute(
                      builder: (context) =>
                          OderguidePage()), // Navigate to Order guide page
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
                  MaterialPageRoute(
                      builder: (context) =>
                          RaiderPageGuide()), // Navigate to Raider guide page
                );
              },
              icon: Icon(Icons.motorcycle),
              label: Text("คู่มือไรเดอร์"),
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
                  MaterialPageRoute(builder: (context) => StoreguidePage()),
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
                  MaterialPageRoute(
                      builder: (context) =>
                          HowtopayPage()), // Navigate to How to pay page
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
                  MaterialPageRoute(
                      builder: (context) =>
                          RuleappPage()), // Navigate to Rules page
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
