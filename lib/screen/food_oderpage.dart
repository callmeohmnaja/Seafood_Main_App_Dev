import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seafood_app/model/cart.dart';
import 'package:seafood_app/screen/foodDetail_page.dart';

class Food {
  final String id; // Add an ID field to uniquely identify each document
  final String name;
  final double price;
  final String imageUrl;

  Food({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory Food.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Food(
      id: doc.id, // Assign the document ID
      name: data['name'] ?? 'Unknown',
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}

class Cart {
  final List<Food> items = [];

  void addItem(Food food) {
    items.add(food);
  }

  double get totalPrice {
    return items.fold(0, (total, current) => total + current.price);
  }
}

class FoodOrderPage extends StatefulWidget {
  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  final Cart cart = Cart();
  late Future<List<Food>> foodItemsFuture;

  @override
  void initState() {
    super.initState();
    foodItemsFuture = fetchFoodItems();
  }

  Future<List<Food>> fetchFoodItems() async {
    final snapshot = await FirebaseFirestore.instance.collection('menu').get();
    return snapshot.docs.map((doc) => Food.fromDocument(doc)).toList();
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
                  builder: (context) => CartPage(cart: cart),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Food>>(
        future: foodItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No food items found.'));
          }

          final foodItems = snapshot.data!;
          return ListView.builder(
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final food = foodItems[index];
              return Card(
                child: ListTile(
                  leading: food.imageUrl.isNotEmpty
                      ? Image.network(
                          food.imageUrl,
                          width: 50,
                          height: 50,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            }
                          },
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return Icon(Icons.error, size: 50);
                          },
                        )
                      : Icon(Icons.image_not_supported, size: 50),
                  title: Text(food.name),
                  subtitle: Text('THB${food.price}'),
                  onTap: () {
                    // Navigate to the food detail page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(food: food),
                      ),
                    );
                  },
                  trailing: ElevatedButton(
                    child: Text('เพิ่มเข้าตะกร้า'),
                    onPressed: () {
                      setState(() {
                        cart.addItem(food);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${food.name} added to cart')),
                        );
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
