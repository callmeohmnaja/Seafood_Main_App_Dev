import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seafood_app/model/food.dart';
import 'dart:math';

// Function to generate a numeric Order ID with 10 digits
String generateNumericOrderId() {
  final random = Random();
  // Generate a numeric order ID with 10 digits
  final orderId = (random.nextInt(9000000000) + 1000000000).toString();
  return orderId;
}

class OrderedListPage extends StatelessWidget {
  final String userUid;

  OrderedListPage({required this.userUid, required List<Food> orderedItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการที่สั่งแล้ว'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // กลับไปยังหน้าเดิม
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userUid', isEqualTo: userUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('เกิดข้อผิดพลาด: ${snapshot.error.toString()}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('ยังไม่มีการสั่งอาหาร'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>?;

              if (data == null) {
                return ListTile(
                  title: Text('ไม่พบข้อมูลคำสั่งซื้อ'),
                );
              }

              final items = data['items'] as List<dynamic>?;

              if (items == null || items.isEmpty) {
                return ListTile(
                  title: Text('ไม่มีรายการในคำสั่งซื้อ'),
                );
              }

              return ExpansionTile(
                title: Text('Order ID: ${data['orderId'] ?? 'ไม่ระบุ'}'),
                subtitle: Text('สถานะ: ${data['status'] ?? 'ไม่ระบุ'}'),
                children: items.map<Widget>((item) {
                  final itemData = item as Map<String, dynamic>;
                  final menuItemName = itemData['menuItemUid'] as String?;
                  final quantity = itemData['quantity'] as int?;

                  if (menuItemName == null || quantity == null) {
                    return ListTile(
                      title: Text('ข้อมูลไม่ครบถ้วน'),
                    );
                  }

                  // Fetch menu item by menuItemUid (which is actually the name here)
                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('menu')
                        .where('name',
                            isEqualTo: menuItemName) // Use name field to search
                        .limit(1)
                        .get(),
                    builder: (context, menuSnapshot) {
                      if (menuSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ListTile(
                          title: Text('กำลังโหลด...'),
                        );
                      }
                      if (menuSnapshot.hasError) {
                        return ListTile(
                          title: Text('เกิดข้อผิดพลาดในการดึงข้อมูลเมนู'),
                        );
                      }

                      final docs = menuSnapshot.data?.docs;
                      if (docs == null || docs.isEmpty) {
                        return ListTile(
                          title: Text('ไม่พบข้อมูลเมนู'),
                        );
                      }

                      final menuData =
                          docs.first.data() as Map<String, dynamic>;
                      final food = Food(
                        name: menuData['name'] ?? 'ไม่ระบุชื่อ',
                        price: (menuData['price'] as num?)?.toDouble() ?? 0.0,
                        imageUrl: menuData['image_url'] ??
                            '', // ใช้ image_url แทน imagePath
                        store: '', description: null, // เพิ่มฟิลด์อื่น ๆ ที่จำเป็น
                      );

                      return ListTile(
                        title: Text('${food.name} x $quantity'),
                        subtitle: Text(
                            'ราคา: ${(food.price * quantity).toStringAsFixed(2)} บาท'),
                      );
                    },
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
