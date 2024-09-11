import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seafood_app/model/food.dart';
import 'package:seafood_app/screen/ordered_list.dart';
import 'dart:math';

// Function to generate a numeric Order ID with 6 or 7 digits
String generateNumericOrderId() {
  final random = Random();
  // Generate a numeric order ID with 6 digits (e.g., 100000 - 999999) or 7 digits (e.g., 1000000 - 9999999)
  final min = 100000; // Minimum value for 6-digit ID
  final max = 999999; // Maximum value for 6-digit ID
  final orderId = (random.nextInt(max - min + 1) + min).toString();
  return orderId;
}

class CartPage extends StatelessWidget {
  final List<Food> items;
  final String userUid; // เพิ่ม userUid เพื่อใช้ในการเก็บข้อมูลการสั่งซื้อ
  final VoidCallback onConfirmOrder;

  CartPage({
    required this.items,
    required this.userUid,
    required this.onConfirmOrder,
  });

  double get totalPrice {
    return items.fold(0, (total, food) => total + food.price);
  }

  Future<void> _confirmOrder(BuildContext context) async {
    try {
      // สร้าง orderId ใหม่
      final orderId = generateNumericOrderId(); // ใช้เลข 6 หลักสร้าง orderId

      // บันทึกข้อมูลการสั่งซื้อไปยัง Firestore
      final orderData = {
        'orderId': orderId,
        'userUid': userUid,
        'status': 'Pending',
        'createdAt': Timestamp.now(),
        'items': items.map((food) {
          return {
            'menuItemUid':
                food.name, // ใช้ชื่ออาหารแทน UID (หรือให้ปรับเป็นจริง)
            'quantity': 1, // สมมุติว่าแต่ละรายการสั่ง 1 ชิ้น
          };
        }).toList(),
      };

      await FirebaseFirestore.instance.collection('orders').add(orderData);

      // เรียก callback การยืนยันการสั่งซื้อ
      onConfirmOrder();

      // นำทางไปยัง OrderedListPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderedListPage(
            orderedItems: items,
            userUid: userUid,
          ),
        ),
      );
    } catch (e) {
      // แสดงข้อความข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาด: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้าของคุณ'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final food = items[index];
                return Card(
                  child: ListTile(
                    leading: food.imageUrl.isNotEmpty
                        ? Image.network(
                            food.imageUrl,
                            width: 50,
                            height: 50,
                          )
                        : Icon(Icons.image_not_supported, size: 50),
                    title: Text(food.name),
                    subtitle: Text('THB${food.price}'),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'รวมทั้งหมด: THB${totalPrice}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _confirmOrder(context); // เรียกใช้งานการยืนยันการสั่งซื้อ
              },
              child: Text('ยืนยันการสั่งอาหาร'),
            ),
          ),
        ],
      ),
    );
  }
}
