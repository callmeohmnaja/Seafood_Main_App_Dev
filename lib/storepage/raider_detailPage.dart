import 'package:flutter/material.dart';
import 'package:seafood_app/storepage/raiderinfo_page.dart';

class RaiderDetailPage extends StatelessWidget {
  final Map<String, dynamic> raiderData;

  const RaiderDetailPage({super.key, required this.raiderData});

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
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: Text('รายละเอียดไรเดอร์'),
        backgroundColor: Colors.green[700],
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
                  border: Border.all(color: Colors.green[700]!, width: 4),
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
                        color: Colors.green[800],
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
                backgroundColor: Colors.green,
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
              color: Colors.green[700],
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
