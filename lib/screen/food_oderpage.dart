import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seafood_app/model/food.dart';
import 'package:seafood_app/model/cart_page.dart';

class FoodOrderPage extends StatefulWidget {
  final List<Food> initialCartItems;

  const FoodOrderPage({super.key, required this.initialCartItems});

  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  late List<Food> cartItems;
  bool isOrdering = false;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    cartItems = widget.initialCartItems;
  }

  void addToCart(Food food) {
    setState(() {
      cartItems.add(food);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${food.name} ถูกเพิ่มเข้าตะกร้า'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  Future<void> _sendOrderNotificationToStore(List<Food> orderedItems, String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (!userDoc.exists || userDoc.data() == null) {
        print('ไม่พบข้อมูลผู้ใช้');
        return;
      }

      final userData = userDoc.data();
      final address = userData?['address'] ?? 'ไม่พบที่อยู่';
      final phone = userData?['phone'] ?? 'ไม่พบเบอร์โทรศัพท์';
      final String restaurantUsername = orderedItems.isNotEmpty ? orderedItems.first.store : 'Unknown'; // เก็บชื่อร้านค้าของเมนูแรก

      // ignore: unused_local_variable
      for (var food in orderedItems) {
        await FirebaseFirestore.instance.collection('food_store_notifications').add({
          'items': orderedItems.map((item) => {
                'name': item.name,
                'price': item.price,
                'imageUrl': item.imageUrl,
              }).toList(),
          'message': 'คุณมีคำสั่งซื้อใหม่จากลูกค้า',
          'userId': userId,
          'address': address,
          'phone': phone,
          'timestamp': Timestamp.now(),
          'username': restaurantUsername,
        });
      }

      print('Notification sent to store successfully.');
    } catch (e) {
      print('Error sending notification to store: $e');
    }
  }

  Future<void> confirmOrder() async {
    if (isOrdering) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('คุณมีคำสั่งซื้อที่กำลังดำเนินการอยู่'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      isOrdering = true;
    });

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณาเข้าสู่ระบบ'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        isOrdering = false;
      });
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
                final userData = userDoc.data();

                if (!userDoc.exists || userData == null || !userData.containsKey('balance')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('ไม่พบข้อมูลยอดเงินของผู้ใช้'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  setState(() {
                    isOrdering = false;
                  });
                  return;
                }

                double currentBalance = (userData['balance'] as num?)?.toDouble() ?? 0.0;
                final userName = userData['username'] ?? 'Unknown'; 

                if (currentBalance < totalOrderAmount) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('ยอดเงินไม่เพียงพอในการสั่งอาหาร'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  setState(() {
                    isOrdering = false;
                  });
                  return;
                }

                final newBalance = currentBalance - totalOrderAmount;
                await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                  'balance': newBalance,
                });

                final restaurantIds = cartItems.map((food) => food.store).toSet();

                // เพิ่มเงินให้กับร้านค้าของเมนูแต่ละรายการ
                for (String store in restaurantIds) {
                  final storeDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .where('username', isEqualTo: store)
                      .get();
                  if (storeDoc.docs.isNotEmpty) {
                    final storeData = storeDoc.docs.first.data();
                    double currentStoreBalance = (storeData['balance'] as num?)?.toDouble() ?? 0.0;
                    final newStoreBalance = currentStoreBalance + cartItems
                        .where((food) => food.store == store)
                        .fold(0.0, (sum, food) => sum + food.price);

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(storeDoc.docs.first.id)
                        .update({
                      'balance': newStoreBalance,
                    });
                  }
                }

                final orderRef = FirebaseFirestore.instance.collection('orders').doc();
                final orderData = {
                  'items': cartItems.map((food) => {
                        'name': food.name,
                        'price': food.price,
                        'imageUrl': food.imageUrl,
                        'store': food.store, 
                      }).toList(),
                  'createdAt': Timestamp.now(),
                  'userId': user.uid,
                  'username': userName,
                  'totalAmount': totalOrderAmount,
                };

                await orderRef.set(orderData);

                final userOrderHistoryRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('order_history')
                    .doc();

                await userOrderHistoryRef.set(orderData);

                await _sendOrderNotificationToStore(cartItems, user.uid);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('การสั่งอาหารได้รับการยืนยัน'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                setState(() {
                  cartItems.clear();
                  isOrdering = false;
                });

                Navigator.of(context).pop(newBalance);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('เกิดข้อผิดพลาดในการบันทึกการสั่งซื้อ: $e'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                setState(() {
                  isOrdering = false;
                });
              }
            },
            child: Text('ยืนยัน', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              setState(() {
                isOrdering = false;
              });
            },
            child: Text('ยกเลิก', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchMenuItemsWithUsername(String query) async {
    QuerySnapshot snapshot;
    if (query.isEmpty) {
      snapshot = await FirebaseFirestore.instance.collection('menu').get();
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection('menu')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();
    }

    List<Map<String, dynamic>> menuItemsWithUsername = [];
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      menuItemsWithUsername.add({
        'food': Food(
          name: data['name'],
          price: (data['price'] as num).toDouble(),
          imageUrl: data['image_url'],
          store: data['username'] ?? '', 
          description: null,
        ),
      });
    }

    return menuItemsWithUsername;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการอาหาร', style: TextStyle()),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'ค้นหาเมนูอาหาร...',
                  hintStyle: TextStyle(),
                  prefixIcon: Icon(Icons.search, color: Colors.teal),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        searchController.clear();
                        searchQuery = '';
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(

                future: fetchMenuItemsWithUsername(searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('ไม่พบเมนูอาหาร', style: TextStyle()),
                    );
                  }

                  final menuItemsWithUsername = snapshot.data!;
                  return ListView.builder(
                    itemCount: menuItemsWithUsername.length,
                    itemBuilder: (context, index) {
                      final food = menuItemsWithUsername[index]['food'] as Food;

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: ListTile(
                          leading: food.imageUrl.isNotEmpty
                              ? Image.network(food.imageUrl, width: 60, height: 60, fit: BoxFit.cover)
                              : Icon(Icons.image_not_supported, size: 60),
                          title: Text(food.name),
                          subtitle: Text('ร้าน: ${food.store} \nTHB ${food.price.toStringAsFixed(2)}'),
                          trailing: ElevatedButton(
                            onPressed: () => addToCart(food),
                            child: Text('เพิ่มเข้าตะกร้า', style: TextStyle()),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
