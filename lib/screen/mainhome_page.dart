import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seafood_app/model/food.dart';
import 'package:seafood_app/screen/book_page.dart';
import 'package:seafood_app/screen/food_app.dart';
import 'package:seafood_app/screen/home.dart';
import 'package:seafood_app/screen/ordered_list.dart';
import 'package:seafood_app/screen/profile.dart';
import 'package:seafood_app/screen/support_page.dart';
import 'package:seafood_app/storepage/restaurant_menu_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('หน้าแรก')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'เมนู',
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
                      builder: (context) => OrderedListPage(
                            // ส่งข้อมูลการสั่งซื้อไปยังหน้า OrderedListPage
                            orderedItems: [], userUid: '',
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
          Expanded(
            child: _searchQuery.isEmpty
                ? Center(child: Text('กรุณาพิมพ์เพื่อค้นหาร้านอาหาร'))
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('role', isEqualTo: 'ร้านอาหาร')
                        .where('username', isGreaterThanOrEqualTo: _searchQuery)
                        .where('username',
                            isLessThanOrEqualTo: '$_searchQuery\uf8ff')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'เกิดข้อผิดพลาด: ${snapshot.error.toString()}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('ไม่พบร้านอาหาร'));
                      }

                      final restaurants = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurants[index];
                          final username = restaurant['username'];
                          final restaurantUid = restaurant['uid'];

                          return FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('menu')
                                .where('customUid', isEqualTo: restaurantUid)
                                .get(),
                            builder: (context, menuSnapshot) {
                              if (menuSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return ListTile(
                                  title: Text(username),
                                  subtitle: Text('กำลังโหลดเมนู...'),
                                );
                              }
                              if (menuSnapshot.hasError) {
                                return ListTile(
                                  title: Text(username),
                                  subtitle: Text(
                                      'เกิดข้อผิดพลาดในการดึงเมนู: ${menuSnapshot.error.toString()}'),
                                );
                              }

                              final menuItems = menuSnapshot.data?.docs ?? [];

                              return ListTile(
                                title: Text(username),
                                subtitle: menuItems.isNotEmpty
                                    ? Text(
                                        'เมนู: ${menuItems.map((menu) => menu['name']).join(', ')}')
                                    : Text('ไม่มีเมนูในร้าน'),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RestaurantMenuPage(
                                          restaurantUid: restaurantUid,
                                          onAddToCart: (Food food) {
                                            // Implement your add to cart functionality here
                                            print(
                                                'Added to cart: ${food.name}');
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
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
