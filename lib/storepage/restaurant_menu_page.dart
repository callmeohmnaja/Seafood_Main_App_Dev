import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:seafood_app/model/food.dart';
import 'package:seafood_app/screen/food_oderpage.dart'; // นำเข้าคลาส Food

class RestaurantMenuPage extends StatelessWidget {
  final String restaurantUid;

  RestaurantMenuPage({
    required this.restaurantUid,
    required Function(Food food) onAddToCart,
  });

  Future<String?> _getImageUrl(String imagePath) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(imagePath);
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching image URL: $e');
      return null;
    }
  }

  void _navigateToOrderPage(BuildContext context, List<Food> cartItems) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodOrderPage(initialCartItems: cartItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Food> cartItems = [];

    return Scaffold(
      appBar: AppBar(title: Text('เมนูของร้าน')),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('menu')
            .where('customUid',
                isEqualTo:
                    restaurantUid) // เปลี่ยนจาก 'restaurantUid' เป็น 'customUid'
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('เกิดข้อผิดพลาด: ${snapshot.error.toString()}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('ไม่มีเมนูในร้าน'));
          }

          final menuItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final menuItem = menuItems[index];
              final name = menuItem['name'] ?? 'ไม่ระบุชื่อ';
              final description = menuItem['description'] ?? 'ไม่มีรายละเอียด';
              final price = menuItem['price']?.toString() ?? '0.0';
              final imagePath = menuItem['image_url'] ?? '';

              return FutureBuilder<String?>(
                future: _getImageUrl(imagePath),
                builder: (context, imageSnapshot) {
                  if (imageSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      leading: CircularProgressIndicator(),
                      title: Text(name),
                      subtitle: Text('$description - ฿$price'),
                    );
                  }
                  if (imageSnapshot.hasError) {
                    return ListTile(
                      contentPadding: EdgeInsets.all(8.0),
                      leading: Icon(Icons.error, size: 80),
                      title: Text(name),
                      subtitle: Text('$description - ฿$price'),
                    );
                  }

                  final imageUrl = imageSnapshot.data;

                  return ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    leading: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.restaurant_menu, size: 80),
                    title: Text(name),
                    subtitle: Text('$description - ฿$price'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        final food = Food(
                          name: name,
                          store: restaurantUid,
                          price: double.tryParse(price) ?? 0.0,
                          imageUrl: imageUrl ?? '',
                        );
                        cartItems.add(food);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$name ถูกเพิ่มเข้าตะกร้า')),
                        );
                        _navigateToOrderPage(context, cartItems);
                      },
                      child: Text('สั่งซื้อ'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
