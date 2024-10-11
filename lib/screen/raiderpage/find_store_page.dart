import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seafood_app/screen/raiderpage/raider_dashboard.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ignore: use_key_in_widget_constructors
class FindStorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตรวจสอบร้าน'),
        backgroundColor: Colors.teal, // ใช้สีเขียวให้เข้ากับธีมของแอป
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => RaiderDashboard()));
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
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
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant =
                          restaurants[index].data() as Map<String, dynamic>;
                      final imageUrl = restaurant['profileImageUrl'] ?? '';

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: imageUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  imageBuilder: (context, imageProvider) => Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error, color: Colors.red),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.grey[200],
                                  radius: 30,
                                  child: Icon(Icons.restaurant_menu,
                                      size: 30, color: Colors.grey),
                                ),
                          title: Text(
                            'ร้าน: ${restaurant['username'] ?? 'ไม่มีชื่อ'}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.teal.shade800,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                'ประเภท: ${restaurant['menu'] ?? 'ไม่มีรายละเอียด'}',
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'ที่อยู่: ${restaurant['address'] ?? 'ไม่พบที่อยู่'}',
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'เบอร์: ${restaurant['phone'] ?? 'ไม่พบเบอร์'}',
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                            ],
                          ),
                          onTap: () {
                            // TODO: เพิ่มการทำงานเมื่อแตะที่ร้านค้าเพื่อดูรายละเอียด
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RaiderDashboard()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // สีพื้นหลังให้เข้ากับธีม
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
      ),
    );
  }
}
