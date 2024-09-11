import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RestaurantMenuPage extends StatelessWidget {
  final String restaurantUid;

  RestaurantMenuPage({required this.restaurantUid});

  Future<String?> _getImageUrl(String imagePath) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(imagePath);
      final url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      print('Error fetching image URL: $e');
      return null;
    }
  }

  void _orderItem(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('คุณสั่งซื้อ $name เรียบร้อยแล้ว')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เมนูของร้าน')),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('menu')
            .where('customUid', isEqualTo: restaurantUid)
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
              final name = menuItem['name'];
              final description = menuItem['description'];
              final price = menuItem['price'];
              final imagePath = menuItem['image_url'];

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
                      onPressed: () => _orderItem(context, name),
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
