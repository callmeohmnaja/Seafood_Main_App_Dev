import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // อย่าลืมเพิ่มแพ็คเก็ตนี้
import 'dart:math'; // สำหรับสุ่มข้อความ

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Menu',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();

  // คำพูดที่สุ่มขึ้นมา
  final List<String> randomMessages = [
    "พบกับกิจกรรมสุดพิเศษได้ที่นี่!",
    "ร่วมสนุกกับโปรโมชั่นพิเศษจากร้านค้าชั้นนำ!",
    "กิจกรรมใหม่ๆ กำลังจะมาถึง รอติดตามได้เลย!",
    "ร่วมเป็นส่วนหนึ่งของกิจกรรมสนุกๆ วันนี้!"
  ];

  // ฟังก์ชันสุ่มคำพูด
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
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView( // ใช้ SingleChildScrollView
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.orange[100],
                  hintText: 'ค้นหาร้านอาหารหรือเมนู',
                  prefixIcon: Icon(Icons.search, color: Colors.deepOrange),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close, color: Colors.deepOrange),
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
                  _buildActionButton('ร้านอาหาร', Icons.restaurant, Colors.deepOrange),
                  _buildActionButton('โปรไฟล์', Icons.person, Colors.blue),
                  _buildActionButton('คิดก่อน', Icons.lightbulb, Colors.green),
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
                                height: 200, // ปรับขนาดภาพให้เล็กลง
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
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
                color: Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    getRandomMessage(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
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

  // ปุ่มที่มีไอคอนและสีตกแต่ง
  Widget _buildActionButton(String label, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {
        // เว้น onPressed ไว้ให้เขียน
      },
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
