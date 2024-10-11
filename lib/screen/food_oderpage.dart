import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seafood_app/model/food.dart';
import 'package:seafood_app/model/cart_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodOrderPage extends StatefulWidget {
  final List<Food> initialCartItems;

  FoodOrderPage({required this.initialCartItems});

  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  late List<Food> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = widget.initialCartItems;
  }

  void addToCart(Food food) {
    setState(() {
      cartItems.add(food);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${food.name} ถูกเพิ่มเข้าตะกร้า'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  // Function to send notification to the restaurant when an order is placed
  Future<void> _sendOrderNotificationToStore(List<Food> orderedItems, String userId) async {
    try {
      for (var food in orderedItems) {
        // Assuming each food item has a 'store' field indicating the restaurant/store ID
        await FirebaseFirestore.instance.collection('food_store_notifications').add({
          'message': 'คุณมีคำสั่งซื้อใหม่จากลูกค้า',
          'items': orderedItems.map((item) => {'name': item.name, 'price': item.price}).toList(),
          'restaurantId': food.store, // Link to specific restaurant
          'userId': userId,
          'timestamp': Timestamp.now(),
        });
      }
      print('Notification sent to store successfully.');
    } catch (e) {
      print('Error sending notification to store: $e');
    }
  }

  Future<void> confirmOrder() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('กรุณาเข้าสู่ระบบ'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final totalOrderAmount = cartItems.fold(0.0, (sum, food) => sum + food.price);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('ยืนยันการสั่งอาหาร'),
        content: Text('คุณต้องการยืนยันการสั่งอาหารหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              try {
                final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

                if (!userDoc.exists || userDoc.data() == null || !userDoc.data()!.containsKey('balance')) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('ไม่พบข้อมูลยอดเงินของผู้ใช้'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                  return;
                }

                double currentBalance = (userDoc['balance'] as num?)?.toDouble() ?? 0.0;

                if (currentBalance < totalOrderAmount) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('ยอดเงินไม่เพียงพอในการสั่งอาหาร'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                  return;
                }

                final newBalance = currentBalance - totalOrderAmount;
                await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                  'balance': newBalance,
                });

                final orderRef = FirebaseFirestore.instance.collection('orders').doc();
                await orderRef.set({
                  'items': cartItems.map((food) => {
                        'name': food.name,
                        'price': food.price,
                        'imageUrl': food.imageUrl,
                        'restaurantId': food.store, // Link to specific restaurant
                      }).toList(),
                  'createdAt': Timestamp.now(),
                  'userId': user.uid,
                  'totalAmount': totalOrderAmount,
                });

                // Save order history in the user's sub-collection called `order_history`
                final userOrderHistoryRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('order_history')
                    .doc();

                await userOrderHistoryRef.set({
                  'orderId': orderRef.id,
                  'items': cartItems.map((food) => {
                        'name': food.name,
                        'price': food.price,
                        'imageUrl': food.imageUrl,
                      }).toList(),
                  'totalAmount': totalOrderAmount,
                  'orderDate': Timestamp.now(),
                });

                // Send notification to the store
                await _sendOrderNotificationToStore(cartItems, user.uid);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('การสั่งอาหารได้รับการยืนยัน'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }

                setState(() {
                  cartItems.clear();
                });

                if (mounted) {
                  Navigator.of(context).pop(newBalance);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('เกิดข้อผิดพลาดในการบันทึกการสั่งซื้อ'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: Text('ยืนยัน', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('ยกเลิก', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<List<Food>> fetchMenuItems() async {
    final snapshot = await FirebaseFirestore.instance.collection('menu').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Food(
        name: data['name'],
        price: (data['price'] as num).toDouble(),
        imageUrl: data['image_url'],
        store: data['storeId'] ?? '', // Store the restaurant/store ID here
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการอาหาร', style: GoogleFonts.prompt()),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Food>>(
        future: fetchMenuItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่มีเมนูอาหาร', style: GoogleFonts.prompt()));
          }

          final menuItems = snapshot.data!;
          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final food = menuItems[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ListTile(
                  leading: food.imageUrl.isNotEmpty
                      ? Image.network(food.imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                      : Icon(Icons.image_not_supported, size: 60),
                  title: Text(food.name),
                  subtitle: Text('THB ${food.price.toStringAsFixed(2)}'),
                  trailing: ElevatedButton(
                    onPressed: () => addToCart(food),
                    child: Text('เพิ่มเข้าตะกร้า', style: GoogleFonts.prompt()),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(
                items: cartItems,
                onConfirmOrder: confirmOrder,
                userUid: FirebaseAuth.instance.currentUser?.uid ?? '',
              ),
            ),
          ).then((_) {
            setState(() {});
          });
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.shopping_cart, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
