import 'package:flutter/material.dart';
import 'package:seafood_app/model/food.dart';
import 'package:seafood_app/model/cart_page.dart'; // นำเข้าหน้า CartPage
import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า Firestore
import 'package:seafood_app/screen/ordered_list.dart'; // นำเข้าหน้า OrderedListPage

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${food.name} added to cart')),
      );
    });
  }

  Future<void> confirmOrder() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ยืนยันการสั่งอาหาร'),
        content: Text('คุณต้องการยืนยันการสั่งอาหารหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // ปิด dialog

              try {
                // บันทึกการสั่งอาหารลง Firestore
                final orderRef =
                    FirebaseFirestore.instance.collection('orders').doc();
                await orderRef.set({
                  'items': cartItems
                      .map((food) => {
                            'name': food.name,
                            'price': food.price,
                            'imageUrl': food.imageUrl,
                          })
                      .toList(),
                  'createdAt': Timestamp.now(),
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('การสั่งอาหารได้รับการยืนยัน')),
                );

                setState(() {
                  cartItems.clear(); // ล้างตะกร้า
                });

                // นำทางไปหน้า OrderedListPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderedListPage(
                      orderedItems: cartItems,
                      userUid: '',
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('เกิดข้อผิดพลาดในการบันทึกการสั่งซื้อ')),
                );
              }
            },
            child: Text('ยืนยัน'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการอาหาร'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    items: cartItems,
                    onConfirmOrder: confirmOrder,
                    userUid: '',
                  ),
                ),
              ).then((_) {
                // รีเฟรชตะกร้าหลังจากกลับมาจากหน้า CartPage
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('ไม่มีรายการอาหารในตะกร้า'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final food = cartItems[index];
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
                    trailing: ElevatedButton(
                      child: Text('เพิ่มเข้าตะกร้า'),
                      onPressed: () => addToCart(food),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
