import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seafood_app/screen/food_app.dart';

class Showstorepage extends StatelessWidget {
  const Showstorepage({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: Text('ร้านอาหาร'),
        backgroundColor: Colors.teal, // ใช้สีพื้นหลังของแอปที่เข้ากับธีม
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FoodApp()));
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'ร้านอาหาร')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('ไม่พบร้านอาหาร'));
                }

                final restaurants = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant =
                        restaurants[index].data() as Map<String, dynamic>;
                    final imageUrl = restaurant['profileImageUrl'] ?? '';

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                radius: 40,
                                child: Icon(Icons.restaurant_menu,
                                    size: 40, color: Colors.grey),
                              ),
                        title: Text(
                          'ร้าน: ${restaurant['username'] ?? 'ไม่มีชื่อ'}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ประเภท: ${restaurant['menu'] ?? 'ไม่มีรายละเอียด'}',
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'ที่อยู่: ${restaurant['address'] ?? 'ไม่พบที่อยู่'}',
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'เบอร์: ${restaurant['phone'] ?? 'ไม่พบเบอร์'}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        onTap: () {
                          // TODO: เชือมไปหน้ารายละเอียดร้าน
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodApp()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // สีพื้นหลัง
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'หน้าหลัก',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

 