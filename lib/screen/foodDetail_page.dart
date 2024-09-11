import 'package:flutter/material.dart';
import 'package:seafood_app/model/food.dart';

class FoodDetailPage extends StatelessWidget {
  final Food food;

  FoodDetailPage({required this.food});

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
                : Icon(Icons.image_not_supported, size: 100),
            SizedBox(height: 16),
            Text(
              food.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 8),
            Text('THB${food.price}',
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
