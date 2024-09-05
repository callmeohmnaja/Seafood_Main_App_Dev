import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า Cloud Firestore
import 'package:seafood_app/screen/food_app.dart';
import 'package:seafood_app/screen/food_oderpage.dart';
import 'package:seafood_app/screen/home.dart';
import 'package:seafood_app/screen/profile.dart';
import 'package:seafood_app/screen/support_page.dart';
import 'book_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = ''; // ค่าของการค้นหา

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
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
              leading: Icon(Icons.support_agent),
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
      body: Column(
        children: [
          // SearchBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'ค้นหาร้านอาหาร',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          // Restaurant List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'ร้านอาหาร')
                  .where('name', isGreaterThanOrEqualTo: _searchQuery)
                  .where('name', isLessThanOrEqualTo: '$_searchQuery\uf8ff')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child:
                          Text('เกิดข้อผิดพลาด: ${snapshot.error.toString()}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('ไม่พบร้านอาหาร'));
                }

                final restaurants = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    final name = restaurant['name'];
                    final menu = restaurant['menu'] ??
                        []; // Assumes menu is a list of items

                    return ListTile(
                      title: Text(name),
                      subtitle:
                          Text('เมนู: ${menu.join(', ')}'), // แสดงเมนูที่ร้านมี
                      onTap: () {
                        // Navigate to restaurant details or menu page
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
