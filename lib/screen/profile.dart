import 'package:flutter/material.dart';
import 'package:seafood_app/screen/book_page.dart';
import 'package:seafood_app/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า Firestore
import 'package:seafood_app/screen/mainhome_page.dart';
import 'package:seafood_app/screen/oder.dart';
import 'package:seafood_app/screen/raider_page.dart';
import 'package:seafood_app/screen/store_page.dart';
import 'package:seafood_app/screen/support_page.dart';

// ignore: use_key_in_widget_constructors
class ProfilePage extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance; // สร้าง instance ของ Firestore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์'),
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
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('ออกจากระบบ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: firestore.collection('users').doc(auth.currentUser?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('โปรไฟล์ไม่พบ'));
          }

          // ดึงข้อมูลจาก Firestore
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String username = userData['username'] ?? 'ไม่ระบุ'; // ดึงชื่อผู้ใช้
          String role = userData['role'] ?? 'ไม่ระบุ'; // ดึงบทบาท

          return Column(
            children: <Widget>[
              // Profile Section
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('images/seafood_logo.png'), // เปลี่ยนที่อยู่ของภาพโปรไฟล์
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ชื่อผู้ใช้: $username', // แสดงชื่อผู้ใช้ที่ดึงจาก Firestore
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'บทบาท: $role', // แสดงบทบาทที่ดึงจาก Firestore
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'อีเมลของคุณคือ: ${auth.currentUser?.email ?? ''}', // แสดงอีเมลของผู้ใช้
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              // List of options in the ListView
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      title: Text('แก้ไขโปรไฟล์'), // ตัวเลือกแก้ไขโปรไฟล์
                      onTap: () {
                        // นำไปหน้าแก้ไขโปรไฟล์ (ถ้ามี)
                      },
                    ),
                    ListTile(
                      title: Text('การตั้งค่าบัญชี'), // ตัวเลือกการตั้งค่าบัญชี
                      onTap: () {
                        // นำไปหน้าการตั้งค่าบัญชี (ถ้ามี)
                      },
                    ),
                    ListTile(
                      title: Text('ประวัติการสั่งซื้อ'), // ตัวเลือกประวัติการสั่งซื้อ
                      onTap: () {
                        // นำไปหน้าประวัติการสั่งซื้อ (ถ้ามี)
                      },
                    ),
                    ListTile(
                      title: Text('ออกจากระบบ'), // ตัวเลือกออกจากระบบ
                      onTap: () {
                        // Implement logout functionality here
                        auth.signOut().then((_) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => HomeScreen()));
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
