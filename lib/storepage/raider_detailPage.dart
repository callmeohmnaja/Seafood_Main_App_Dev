import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seafood_app/storepage/raiderinfo_page.dart';

class RaiderDetailPage extends StatelessWidget {
  final Map<String, dynamic> raiderData;

  const RaiderDetailPage({super.key, required this.raiderData});

  // ฟังก์ชันสำหรับบันทึกการแจ้งเตือนใน Firestore
  Future<void> _sendNotification(BuildContext context) async {
    try {
      String? restaurantName = 'ชื่อร้านอาหารที่ไม่ทราบ';
      String? restaurantProfileImageUrl;
      String? storeId; // Store ID (uid ของร้าน)
      String? riderUsername = raiderData['username']; // Username ของไรเดอร์

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // ดึงข้อมูลของร้านค้าจาก Firestore
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        restaurantName = userDoc.data()?['username'] ?? 'ชื่อร้านอาหารที่ไม่ทราบ';
        restaurantProfileImageUrl = userDoc.data()?['profileImageUrl'] ?? '';
        storeId = user.uid; // ใช้ uid ของผู้ใช้ปัจจุบันเป็น storeId
      }

      // บันทึกข้อมูลแจ้งเตือนไปยัง Firestore
      await FirebaseFirestore.instance.collection('notifications').add({
        'message': 'คุณได้รับการกดรับการพิจารณาจากร้านอาหาร โปรดรอการติดต่อเร็วๆนี้!',
        'userId': raiderData['uid'], // uid ของไรเดอร์
        'username': riderUsername, // ส่ง username ของไรเดอร์ไปด้วย
        'restaurantName': restaurantName,
        'restaurantProfileImageUrl': restaurantProfileImageUrl,
        'storeId': storeId, // เพิ่ม storeId
        'timestamp': Timestamp.now(),
      });

      // แสดงข้อความยืนยันว่าการแจ้งเตือนถูกส่งสำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('การแจ้งเตือนถูกส่งไปยังไรเดอร์แล้ว!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // แสดงข้อความหากเกิดข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาดในการส่งการแจ้งเตือน: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = raiderData['email'] ?? 'ไม่มีข้อมูล';
    final username = raiderData['username'] ?? 'ไม่มีข้อมูล';
    final vehicle = raiderData['vehicle'] ?? 'ไม่มีข้อมูล';
    final contactNumber = raiderData['contactNumber'] ?? 'ไม่มีข้อมูล';
    final fullName = raiderData['fullName'] ?? 'ไม่มีข้อมูล';
    final faculty = raiderData['faculty'] ?? 'ไม่มีข้อมูล';
    final department = raiderData['department'] ?? 'ไม่มีข้อมูล';
    final profileImageUrl = raiderData['profileImageUrl'] ?? '';

    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: AppBar(
        title: Text('รายละเอียดไรเดอร์'),
        backgroundColor: Colors.brown.shade50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.brown.shade700, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: profileImageUrl.isNotEmpty
                      ? Image.network(
                          profileImageUrl,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ชื่อผู้ใช้: $username',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.brown.shade800,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildDetailRow('อีเมล:', email),
                    _buildDetailRow('รถ:', vehicle),
                    _buildDetailRow('เบอร์ติดต่อ:', contactNumber),
                    _buildDetailRow('ชื่อจริง-นามสกุล:', fullName),
                    _buildDetailRow('คณะ:', faculty),
                    _buildDetailRow('สาขา:', department),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RaiderinfoPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 184, 81, 49),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'ย้อนกลับ',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _sendNotification(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'ส่งแจ้งเตือนไปยังไรเดอร์',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.brown.shade700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}
