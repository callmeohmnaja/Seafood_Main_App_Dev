import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:seafood_app/screen/addmoney_page.dart';
import 'package:seafood_app/screen/chatborad.dart';
import 'package:seafood_app/screen/food_oderpage.dart';
import 'package:seafood_app/screen/home.dart';
import 'package:seafood_app/screen/profile/profile.dart';
import 'package:seafood_app/screen/DetailFood.dart';
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
    "รู้หรือไม่? กลุ่ม Seafood ของเราเริ่มต้นจากการเล่นเกมแล้วสร้างบ้านริมทะเลแล้วพัฒนาเป็นชื่อทีม!",
    "ยินดีต้อนรับสู่แอปพลิเคชันของเรา! อิ่มอร่อยไปกับอาหารจากเรา",
    "สวัสดีครับผมนาย อิราธิวัฒน์ บันโสภา เป็นAdmin ของแอปพลิเคชัน (หิวไหมเคยู)Ku Food Delivery"
  ];

  late String _randomMessage;
  double userBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _randomMessage = getRandomMessage();
    _fetchUserBalance();
  }

  String getRandomMessage() {
    return randomMessages[Random().nextInt(randomMessages.length)];
  }

  Future<void> _fetchUserBalance() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          userBalance = (userDoc['balance'] ?? 0.0).toDouble();
        });
      }
    } catch (e) {
      print('Error fetching user balance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Ku Food Delivery', style: GoogleFonts.prompt(fontSize: 26)),
        backgroundColor: Colors.teal,
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
                _buildBalanceCard(),
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildQuickActions(context),
                const SizedBox(height: 20),
                _buildCarouselMenu(), // แสดง Carousel Menu
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
              style: GoogleFonts.prompt(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            Text(
              '${userBalance.toStringAsFixed(2)} บาท',
              style: GoogleFonts.prompt(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
          ],
        ),
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
          hintStyle: GoogleFonts.prompt(),
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
        _buildActionButton('ร้านอาหาร', Icons.restaurant, Colors.orangeAccent,
            () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Showstorepage()));
        }),
        _buildActionButton('โปรไฟล์', Icons.person, Colors.lightBlue, () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfilePage()));
        }),
        _buildActionButton('เติมเงิน', Icons.attach_money, Colors.green, () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddMoneyPage()));
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
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: GoogleFonts.prompt()));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final menuItems = snapshot.data?.docs ?? [];

        if (menuItems.isEmpty) {
          return Center(
            child: Text(
              'No menu items found',
              style: GoogleFonts.prompt(fontSize: 18),
            ),
          );
        }

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
            final foodId = item.id; // เก็บ foodId

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetailPage(foodId: foodId),
                  ),
                );
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
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
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
                          style: GoogleFonts.prompt(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
          style: GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.bold),
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
            decoration: BoxDecoration(color: Colors.teal),
            child: Text('Menu',
                style: GoogleFonts.prompt(color: Colors.white, fontSize: 24)),
          ),
          _buildDrawerItem(Icons.home, 'หน้าแรก', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          }),
          _buildDrawerItem(Icons.restaurant_menu, 'รายการอาหาร', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FoodOrderPage(initialCartItems: [])));
          }),
          _buildDrawerItem(Icons.chat, 'Ku Chat', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatBoardPage()));
          }),
          _buildDrawerItem(Icons.person, 'โปรไฟล์', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          }),
          _buildDrawerItem(Icons.support, 'แจ้งปัญหา', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SupportPage()));
          }),
          _buildDrawerItem(Icons.logout, 'ออกจากระบบ', () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: GoogleFonts.prompt()),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: GoogleFonts.prompt(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
