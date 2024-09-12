import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seafood_app/screen/raiderpage/raider_dashboard.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FindStorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ค้นหาร้านอาหาร'),
        backgroundColor: Colors.grey, // ใช้สีพื้นหลังของแอปที่เข้ากับธีม
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
                          restaurant['username'] ?? 'ไม่มีชื่อ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          restaurant['menu'] ?? 'ไม่มีรายละเอียด',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        onTap: () {
                          // TODO: Implement navigation to restaurant detail page
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
                  MaterialPageRoute(
                      builder: (context) =>
                          RaiderDashboard()), // ตรวจสอบให้แน่ใจว่า RaiderDashboard ถูกกำหนดไว้
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // สีพื้นหลัง
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