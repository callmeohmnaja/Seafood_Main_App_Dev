import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seafood_app/screen/profile/profile.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  Future<List<Map<String, dynamic>>> fetchOrderHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // กรณีที่ผู้ใช้ไม่ล็อกอิน
      return [];
    }

    try {
      // ดึงข้อมูลจาก collection order_history ของผู้ใช้ปัจจุบัน
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('order_history')
          .orderBy('createdAt', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      // แสดงข้อผิดพลาดถ้ามี
      print('Error fetching order history: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการสั่งซื้อ'),
        backgroundColor: Colors.teal,
        leading: IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
        }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchOrderHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่มีประวัติการสั่งซื้อ'));
          }

          final orderHistory = snapshot.data!;
          return ListView.builder(
            itemCount: orderHistory.length,
            padding: EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final order = orderHistory[index];

              // ดึงวันที่สั่งซื้อและรายการสินค้า
              final orderDate = (order['createdAt'] as Timestamp).toDate();
              final items = order['items'] as List<dynamic>;
              final totalAmount = order['totalAmount'] ?? 0;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: ExpansionTile(
                  title: Text(
                    'วันที่สั่งซื้อ: ${orderDate.day}/${orderDate.month}/${orderDate.year}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    'ยอดรวม: ${totalAmount.toStringAsFixed(2)} THB',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: items.map<Widget>((item) {
                    return ListTile(
                      leading: item['imageUrl'] != null && item['imageUrl'].isNotEmpty
                          ? Image.network(
                              item['imageUrl'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image_not_supported, size: 50),
                      title: Text(item['name'] ?? 'ไม่ทราบชื่อ'),
                      subtitle: Text('THB ${item['price']}'),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
      
    );
  }
}
