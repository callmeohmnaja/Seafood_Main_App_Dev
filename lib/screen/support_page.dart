import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seafood_app/screen/book_page.dart';
import 'package:seafood_app/screen/food_app.dart';
import 'package:seafood_app/screen/food_oderpage.dart';
import 'package:seafood_app/screen/mainhome_page.dart';
import 'package:seafood_app/screen/profile.dart';

class SupportPage extends StatelessWidget {
  final TextEditingController _issueController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แจ้งปัญหา'),
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
                  MaterialPageRoute(builder: (context) => FoodApp()),
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
                  MaterialPageRoute(
                      builder: (context) => FoodOrderPage(
                            initialCartItems: [],
                          )),
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
                  MaterialPageRoute(builder: (context) => Guide()),
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
                  MaterialPageRoute(
                      builder: (context) => HomePage()), // แก้ให้กลับไปหน้าหลัก
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'กรุณาแจ้งปัญหาที่คุณพบ:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _issueController,
              maxLines: 5, // จำนวนบรรทัดสูงสุด
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'กรุณากรอกปัญหาของคุณที่นี่...',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String issue = _issueController.text;
                if (issue.isNotEmpty) {
                  // เก็บข้อมูลลง Firestore
                  await _firestore.collection('support_issues').add({
                    'issue': issue,
                    'timestamp':
                        FieldValue.serverTimestamp(), // เพิ่ม timestamp
                  }).then((_) {
                    // แสดงข้อความยืนยัน
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('แจ้งปัญหา'),
                        content: Text('คุณได้แจ้งปัญหาดังนี้: \n\n$issue'),
                        actions: [
                          TextButton(
                            child: Text('ตกลง'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              _issueController
                                  .clear(); // ล้างข้อมูลใน TextField
                            },
                          ),
                        ],
                      ),
                    );
                  }).catchError((error) {
                    // แสดงข้อผิดพลาด
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
                    );
                  });
                } else {
                  // แจ้งให้ผู้ใช้กรอกปัญหา
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('กรุณากรอกปัญหาของคุณ')),
                  );
                }
              },
              child: Text('ส่งปัญหา'),
            ),
          ],
        ),
      ),
    );
  }
}
