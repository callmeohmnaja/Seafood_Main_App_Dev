import 'package:flutter/material.dart';
import 'package:seafood_app/screen/food_oderpage.dart';

class FoodDetailPage extends StatelessWidget {
  final Food food;

  const FoodDetailPage({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            food.imageUrl.isNotEmpty
                ? Image.network(food.imageUrl)
                : Icon(Icons.image_not_supported, size: 150),
            SizedBox(height: 16),
            Text(
              food.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Price: THB${food.price}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            // You can add more details here if needed
            Text(
              'Description: This is a description of the food item. You can add more details here.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
