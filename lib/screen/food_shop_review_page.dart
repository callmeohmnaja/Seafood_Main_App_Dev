// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:seafood_app/screen/food_app.dart';

// class FoodShopReviewPage extends StatefulWidget {
//   @override
//   _FoodShopReviewPageState createState() => _FoodShopReviewPageState();
// }

// class _FoodShopReviewPageState extends State<FoodShopReviewPage> {
//   double _foodRating = 0.0;
//   double _shopRating = 0.0;
//   TextEditingController _foodCommentController = TextEditingController();
//   TextEditingController _shopCommentController = TextEditingController();

//   Map<String, String> _foodMenu = {}; // Mapping food items to their shop owners
//   Map<String, String> _shopOwners = {}; // Mapping shop owners with their IDs
//   String? _selectedFood;
//   String? _selectedShop;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMenuData();
//     _fetchShopOwners();
//   }

//   // Function to fetch food menu items from Firestore
//   Future<void> _fetchMenuData() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('menu').get();
//       setState(() {
//         _foodMenu = {for (var doc in snapshot.docs) doc['name']: doc['ownerId']};
//       });
//     } catch (e) {
//       print('Error fetching menu data: $e');
//     }
//   }

//   // Function to fetch shop owners from Firestore
//   Future<void> _fetchShopOwners() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'ร้านอาหาร').get();
//       setState(() {
//         _shopOwners = {for (var doc in snapshot.docs) doc.id: doc['shopName']};
//       });
//     } catch (e) {
//       print('Error fetching shop owner data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('รีวิวร้านอาหาร และ อาหาร'),
//         leading: IconButton(onPressed: () {
//           Navigator.pop(context);
//           Navigator.push(context,MaterialPageRoute(builder: (context) => FoodApp()));
//         }, icon: Icon(Icons.arrow_back_ios_new)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Dropdown for Food Menu Selection
//             Text(
//               'เลือกอาหารที่จะรีวิว:',
//               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             DropdownButton<String>(
//               hint: Text('โปรดเลือกโหมดหมู่'),
//               value: _selectedFood,
//               isExpanded: true,
//               items: _foodMenu.keys.map((String food) {
//                 return DropdownMenuItem<String>(
//                   value: food,
//                   child: Text(food),
//                 );
//               }).toList(),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedFood = newValue;
//                   _selectedShop = _shopOwners[_foodMenu[newValue]]; // Match the shop owner with the food item
//                 });
//               },
//             ),
//             SizedBox(height: 20),

//             // Display Selected Shop
//             if (_selectedShop != null)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Shop: $_selectedShop',
//                     style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),

//             // Section for Food Review
//             Text(
//               'เลือกระดับดาวตามความพึงพอใจ:',
//               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             RatingBar.builder(
//               initialRating: 0,
//               minRating: 1,
//               direction: Axis.horizontal,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemBuilder: (context, _) => Icon(
//                 Icons.star,
//                 color: Colors.amber,
//               ),
//               onRatingUpdate: (rating) {
//                 setState(() {
//                   _foodRating = rating;
//                 });
//               },
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _foodCommentController,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 hintText: 'พิมพ์ข้อความที่นี้',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),

//             // Section for Shop Review
//             Text(
//               'เลือกระดับดาวตามความพึงพอใจ:',
//               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             RatingBar.builder(
//               initialRating: 0,
//               minRating: 1,
//               direction: Axis.horizontal,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemBuilder: (context, _) => Icon(
//                 Icons.star,
//                 color: Colors.amber,
//               ),
//               onRatingUpdate: (rating) {
//                 setState(() {
//                   _shopRating = rating;
//                 });
//               },
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _shopCommentController,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 hintText: 'พิมพ์ข้อความที่นี้',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),

//             // Submit Button
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   String foodComment = _foodCommentController.text;
//                   String shopComment = _shopCommentController.text;
//                   print('Selected Food: $_selectedFood');
//                   print('Food Rating: $_foodRating');
//                   print('Food Comment: $foodComment');
//                   print('Shop: $_selectedShop');
//                   print('Shop Rating: $_shopRating');
//                   print('Shop Comment: $shopComment');
//                 },
//                 child: Text('ส่งรีวิว'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
