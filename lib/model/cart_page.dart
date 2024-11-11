import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seafood_app/model/food.dart';
import 'package:seafood_app/screen/ordered_list.dart';
import 'dart:math';

// Function to generate a numeric Order ID with 6 or 7 digits
String generateNumericOrderId() {
  final random = Random();
  final min = 100000; // Minimum value for 6-digit ID
  final max = 999999; // Maximum value for 6-digit ID
  final orderId = (random.nextInt(max - min + 1) + min).toString();
  return orderId;
}

class CartPage extends StatefulWidget {
  final List<Food> items;
  final String userUid;
  final VoidCallback onConfirmOrder;

  const CartPage({super.key, 
    required this.items,
    required this.userUid,
    required this.onConfirmOrder,
  });

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Food> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = List.from(widget.items); // คัดลอกรายการสินค้าเริ่มต้น
  }

  double get totalPrice {
    return cartItems.fold(0, (total, food) => total + food.price);
  }

  void removeFromCart(int index) {
    setState(() {
      cartItems.removeAt(index); // ลบรายการที่เลือกออกจากตะกร้า
    });
  }

  // ฟังก์ชันรวมอาหารที่ซ้ำกัน
  List<Map<String, dynamic>> mergeCartItems() {
    final Map<String, Map<String, dynamic>> mergedItems = {};

    for (var food in cartItems) {
      if (mergedItems.containsKey(food.name)) {
        mergedItems[food.name]!['quantity'] += 1; // เพิ่มจำนวนถ้าชื่ออาหารซ้ำกัน
      } else {
        mergedItems[food.name] = {
          'menuItemUid': food.name,
          'quantity': 1, // จำนวนเริ่มต้นเป็น 1
          'price': food.price,
        };
      }
    }

    return mergedItems.values.toList();
  }

  Future<void> _confirmOrder(BuildContext context) async {
    try {
      // สร้าง orderId ใหม่
      final orderId = generateNumericOrderId(); // ใช้เลข 6 หลักสร้าง orderId

      // รวบรวมรายการอาหารที่ซ้ำกัน
      final mergedItems = mergeCartItems();

      // บันทึกข้อมูลการสั่งซื้อไปยัง Firestore
      final orderData = {
        'orderId': orderId,
        'userUid': widget.userUid,
        'status': 'Pending',
        'createdAt': Timestamp.now(),
        'items': mergedItems,
      };

      await FirebaseFirestore.instance.collection('orders').add(orderData);

      // เรียก callback การยืนยันการสั่งซื้อ
      widget.onConfirmOrder();

      // นำทางไปยัง OrderedListPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderedListPage(
            orderedItems: cartItems,
            userUid: widget.userUid,
          ),
        ),
      );
    } catch (e) {
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
        title: Text('ตะกร้าของคุณ', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal,
              Colors.teal.shade600,
              Colors.teal.shade900,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: cartItems.isEmpty
                  ? Center(
                      child: Text(
                        'ไม่มีรายการในตะกร้า',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final food = cartItems[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: food.imageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      food.imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(Icons.image_not_supported, size: 50),
                            title: Text(food.name, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('THB${food.price}'),
                            trailing: IconButton(
                              icon: Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () {
                                removeFromCart(index); // ลบเมนูอาหารที่ไม่ต้องการออก
                              },
                              tooltip: 'ลบรายการนี้',
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'รวมทั้งหมด: THB$totalPrice',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: cartItems.isEmpty
                    ? null // ปิดการทำงานปุ่มถ้าไม่มีสินค้าในตะกร้า
                    : () {
                        _confirmOrder(context); // เรียกใช้งานการยืนยันการสั่งซื้อ
                      },
                icon: Icon(Icons.check_circle),
                label: Text('ยืนยันการสั่งอาหาร'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
