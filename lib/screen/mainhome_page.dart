import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:seafood_app/main.dart';
import 'package:seafood_app/screen/book_page.dart';
import 'package:seafood_app/screen/food_app.dart';
import 'package:seafood_app/screen/food_oderpage.dart';
import 'package:seafood_app/screen/profile/profile.dart';
import 'package:seafood_app/screen/showstorepage.dart';
import 'dart:math';
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
    //todo เพิ่มข้อความเข้าไปนะจ๊ะขอเยอะๆเบิ้มๆ
    "รู้หรือไม่ชื่อกลุ่มSeafood นั้นไม่ได้มาจากอาหารทะเล \nแต่เป็นการที่พวกเราเล่นเกมแล้วสร้างบ้านริมทะเล \n และขี่เรือไปบุกบ้านคนอื่นเลยกําเนิดเป็น กลุ่ม Seafood!",
    "สวัสดีครับผม นาย อิราธิวัฒน์ บันโสภา ชื่อเล่น โอม เรียน คณะ วิทยาศาสตร์และวิศวกรรมศาสตร์ สาขา วิศวกรรมคอมพิวเตอร์",
    "สวัสดีครับผม นาย อิราธิวัฒน์ บันโสภา ชื่อเล่น โอม เรียน คณะ วิทยาศาสตร์และวิศวกรรมศาสตร์ สาขา วิศวกรรมคอมพิวเตอร์",
    "สวัสดีครับผม นาย อิราธิวัฒน์ บันโสภา ชื่อเล่น โอม เรียน คณะ วิทยาศาสตร์และวิศวกรรมศาสตร์ สาขา วิศวกรรมคอมพิวเตอร์"
  ];

  late String _randomMessage; // เพิ่มตัวแปรสถานะเพื่อเก็บข้อความสุ่ม

  @override
  void initState() {
    super.initState();
    _randomMessage = getRandomMessage(); // สุ่มข้อความครั้งเดียวใน initState
  }

  String getRandomMessage() {
    final random = Random();
    return randomMessages[random.nextInt(randomMessages.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าหลัก'),
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 44, 135, 209),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
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
                Navigator.push(context ,
                MaterialPageRoute(builder: (context) => MyHomePage()));
              },
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 174, 197, 216),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 54, 155, 238),
                  hintText: 'ค้นหาร้านอาหารหรือเมนู',
                  prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close, color: Colors.deepPurple),
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton('ร้านอาหาร', Icons.restaurant, Colors.deepOrange, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Showstorepage())
                    );
                  }),
                  _buildActionButton('โปรไฟล์', Icons.person, Colors.blue, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                  }),
                  _buildActionButton('คู่มือ', Icons.book, Colors.green, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Guide()));
                  }),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
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

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CarouselSlider.builder(
                        itemCount: menuItems.length,
                        options: CarouselOptions(
                          height: 300,
                          enlargeCenterPage: true,
                          autoPlay: true,
                        ),
                        itemBuilder: (context, index, realIndex) {
                          final item = menuItems[index];
                          final name = item['name'];
                          final imageUrl = item['image_url'];
                          
                          

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 8,
                              shadowColor: Colors.black54,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      height: 200,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      // SizedBox(height: 16), // เพิ่มช่องว่างเพื่อหลีกเลี่ยงการ overflow
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _randomMessage, // แสดงข้อความสุ่มที่เก็บไว้
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 24, 24, 24),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
  return ElevatedButton.icon(
    onPressed: onPressed, // แก้ไขเพื่อให้สามารถส่งฟังก์ชันการทำงานเข้ามาได้
    icon: Icon(icon, color: Colors.white),
    label: Text(label),
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
}
