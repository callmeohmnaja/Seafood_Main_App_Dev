import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seafood_app/screen/book_page.dart';
import 'package:seafood_app/screen/food_app.dart';
import 'package:seafood_app/screen/food_oderpage.dart';
import 'package:seafood_app/screen/mainhome_page.dart';
import 'package:seafood_app/screen/profile/profile.dart';

class SupportPage extends StatelessWidget {
  final TextEditingController _issueController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แจ้งปัญหา'),
        backgroundColor: const Color.fromARGB(255, 44, 135, 209),
      ),
      drawer: _buildDrawer(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'กรุณาแจ้งปัญหาที่คุณพบ:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Changed to white for better contrast
                ),
              ),
              SizedBox(height: 16),
              _buildIssueInputCard(),
              SizedBox(height: 20),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIssueInputCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          controller: _issueController,
          maxLines: 5,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintText: 'กรุณากรอกปัญหาของคุณที่นี่...',
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          String issue = _issueController.text;
          if (issue.isNotEmpty) {
            await _firestore.collection('support_issues').add({
              'issue': issue,
              'timestamp': FieldValue.serverTimestamp(),
            }).then((_) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  title: Text('แจ้งปัญหา'),
                  content: Text(
                    'คุณได้แจ้งปัญหาดังนี้:\n\n$issue',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  actions: [
                    TextButton(
                      child: Text('ตกลง'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _issueController.clear();
                      },
                    ),
                  ],
                ),
              );
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
              );
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('กรุณากรอกปัญหาของคุณ')),
            );
          }
        },
        icon: Icon(Icons.send, color: Colors.white),
        label: Text('ส่งปัญหา', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 5,
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Text(
              'เมนู',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDrawerItem(Icons.home, 'หน้าแรก', context, FoodApp()),
          _buildDrawerItem(Icons.restaurant_menu, 'ออเดอร์ของฉัน', context, FoodOrderPage(initialCartItems: [])),
          _buildDrawerItem(Icons.book, 'คู่มือการใช้งาน', context, Guide()),
          _buildDrawerItem(Icons.person, 'โปรไฟล์', context, ProfilePage()),
          _buildDrawerItem(Icons.support, 'แจ้งปัญหา', context, SupportPage()),
          _buildDrawerItem(Icons.logout, 'ออกจากระบบ', context, HomePage()),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}
