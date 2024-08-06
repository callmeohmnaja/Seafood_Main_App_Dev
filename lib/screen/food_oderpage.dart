// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:seafood_app/screen/patment_page.dart'; // Assuming this exists

class Food {
  final String name;
  final double price;
  final String imageUrl;

  Food({required this.name, required this.price, required this.imageUrl});
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

// ignore: use_key_in_widget_constructors
class FoodOrderPage extends StatefulWidget {
  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  final Cart cart = Cart();

  final List<Food> foodItems = [
    Food(name: 'พิซซ่า ', price: 85.0, imageUrl: 'https://www.foodandwine.com/thmb/Wd4lBRZz3X_8qBr69UOu2m7I2iw=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/classic-cheese-pizza-FT-RECIPE0422-31a2c938fc2546c9a07b7011658cfd05.jpg'),
    Food(name: 'กะเพราหมูสับไข่ดาว', price: 45.5, imageUrl: 'https://images.deliveryhero.io/image/fd-th/LH/ws9f-listing.jpg'),
    Food(name: '?', price: 35.0, imageUrl: 'https://f.ptcdn.info/457/080/000/rtr3pk1uuh69g6yUBOqkp-o.jpg'),
    Food(name: '?', price: 35.0, imageUrl: 'https://f.ptcdn.info/457/080/000/rtr3pk1uuh69g6yUBOqkp-o.jpg'),
    Food(name: '?', price: 35.0, imageUrl: 'https://f.ptcdn.info/457/080/000/rtr3pk1uuh69g6yUBOqkp-o.jpg'),
    Food(name: '?', price: 35.0, imageUrl: 'https://f.ptcdn.info/457/080/000/rtr3pk1uuh69g6yUBOqkp-o.jpg'),
    
    // Add more food items here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการอาหาร'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Show cart or navigate to cart page
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
      body: ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          final food = foodItems[index];
          return Card(
            child: ListTile(
              leading: Image.network(food.imageUrl, width: 50, height: 50),
              title: Text(food.name),
              subtitle: Text('THB${food.price}'),
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
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final Cart cart;

  // ignore: use_super_parameters
  const CartPage({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการสินค้าของคุณ'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final food = cart.items[index];
                return ListTile(
                  title: Text(food.name),
                  subtitle: Text('THB${food.price}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'ทั้งหมด: THB${cart.totalPrice}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the payment page with total amount
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(totalAmount: cart.totalPrice),
                ),
              );
            },
            child: Text('Checkout'),
          ),
        ],
      ),
    );
  }
}

