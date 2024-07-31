import 'package:flutter/material.dart';
import 'package:seafood_app/screen/food_oderpage.dart';
import 'package:seafood_app/screen/patment_page.dart';

class CartPage extends StatelessWidget {
  final Cart cart;

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
                  subtitle: Text('\THB${food.price}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'ทั้งหมด: \THB${cart.totalPrice}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the payment page
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
