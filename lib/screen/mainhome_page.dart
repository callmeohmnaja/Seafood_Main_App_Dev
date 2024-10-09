import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:seafood_app/main.dart';
import 'package:seafood_app/screen/book_page.dart';
import 'package:seafood_app/screen/food_app.dart';
import 'package:seafood_app/screen/food_oderpage.dart';
import 'package:seafood_app/screen/profile/profile.dart';
import 'package:seafood_app/screen/showstorepage.dart';
import 'package:seafood_app/screen/support_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();

  final List<String> randomMessages = [
    "รู้หรือไม่? กลุ่ม Seafood ของเราเริ่มต้นจากการสร้างบ้านริมทะเลแล้วพัฒนาเป็นทีม!",
    "ยินดีต้อนรับสู่แอปอาหารทะเล! อิ่มอร่อยไปกับอาหารทะเลสดใหม่จากเรา"
  ];

  late String _randomMessage;
  double userBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _randomMessage = getRandomMessage();
    _fetchUserBalanceFromTransactions();
  }

  String getRandomMessage() {
    return randomMessages[Random().nextInt(randomMessages.length)];
  }

  Future<void> _fetchUserBalanceFromTransactions() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final QuerySnapshot transactionsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('transactions')
            .get();

        double totalAmount = 0.0;
        for (var doc in transactionsSnapshot.docs) {
          totalAmount += (doc['amount'] ?? 0).toDouble();
        }

        setState(() {
          userBalance = totalAmount;
        });
      }
    } catch (e) {
      print('Error fetching user transactions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seafood App'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: _buildDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildWelcomeMessage(), // ย้ายข้อความต้อนรับมาที่ด้านบนสุด
                const SizedBox(height: 20),
                _buildBalanceCard(), // ย้ายยอดเงินมาอยู่ข้างล่างข้อความต้อนรับ
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildQuickActions(context),
                const SizedBox(height: 20),
                _buildCarouselMenu(),
                const SizedBox(height: 20),
                _buildRandomMessageCard(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ยอดเงินในระบบ:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            Text(
              '${userBalance.toStringAsFixed(2)} บาท',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Text(
      'ยินดีต้อนรับสู่ Seafood App!',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'ค้นหาร้านอาหารหรือเมนู',
          prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
          suffixIcon: IconButton(
            icon: Icon(Icons.close, color: Colors.redAccent),
            onPressed: () {
              setState(() {
                searchController.clear();
                searchQuery = '';
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton('ร้านอาหาร', Icons.restaurant, Colors.orangeAccent, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Showstorepage()));
        }),
        _buildActionButton('โปรไฟล์', Icons.person, Colors.lightBlue, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
        }),
        _buildActionButton('คู่มือ', Icons.book, Colors.green, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Guide()));
        }),
      ],
    );
  }

  Widget _buildCarouselMenu() {
    return StreamBuilder<QuerySnapshot>(
      stream: (searchQuery.isEmpty)
          ? FirebaseFirestore.instance.collection('menu').snapshots()
          : FirebaseFirestore.instance
              .collection('menu')
              .where('name', isGreaterThanOrEqualTo: searchQuery)
              .where('name', isLessThanOrEqualTo: searchQuery + '\uf8ff')
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final menuItems = snapshot.data?.docs ?? [];

        return CarouselSlider.builder(
          itemCount: menuItems.length,
          options: CarouselOptions(
            height: 250,
            enlargeCenterPage: true,
            autoPlay: true,
          ),
          itemBuilder: (context, index, realIndex) {
            final item = menuItems[index];
            final name = item['name'];
            final imageUrl = item['image_url'];

            return GestureDetector(
              onTap: () {
                // Implement navigation to the menu details page
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          height: 160,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRandomMessageCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _randomMessage,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          _buildDrawerItem(Icons.home, 'หน้าแรก', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FoodApp()));
          }),
          _buildDrawerItem(Icons.restaurant_menu, 'ออเดอร์ของฉัน', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FoodOrderPage(initialCartItems: [])));
          }),
          _buildDrawerItem(Icons.book, 'คู่มือการใช้งาน', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Guide()));
          }),
          _buildDrawerItem(Icons.person, 'โปรไฟล์', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          }),
          _buildDrawerItem(Icons.support, 'แจ้งปัญหา', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SupportPage()));
          }),
          _buildDrawerItem(Icons.logout, 'ออกจากระบบ', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
