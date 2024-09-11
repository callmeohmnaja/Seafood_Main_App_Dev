import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String name;
  final String store; // ใช้ 'store' ตามที่ใช้ใน Firestore
  final double price;
  final String imageUrl;

  Food({
    required this.name,
    required this.store,
    required this.price,
    required this.imageUrl,
  });

  // Static method to create a Food instance from a Firestore document snapshot
  static Food fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Food(
      name: data['name'] ?? 'Unknown', // Handle missing fields gracefully
      store: data['store'] ?? 'Unknown',
      price: (data['price'] as num).toDouble(), // Convert to double if needed
      imageUrl: data['imageUrl'] ??
          '', // Ensure this field matches your Firestore schema
    );
  }
}
