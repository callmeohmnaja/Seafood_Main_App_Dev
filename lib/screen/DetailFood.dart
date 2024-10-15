import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seafood_app/screen/food_app.dart';

class FoodDetailPage extends StatelessWidget {
  final String foodId;

  FoodDetailPage({required this.foodId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดอาหาร', style: GoogleFonts.prompt(fontSize: 24)),
        backgroundColor: Colors.teal,
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.teal.shade200],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('menu').doc(foodId).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              var foodData = snapshot.data!.data() as Map<String, dynamic>;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // รูปภาพอาหาร
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          foodData['image_url'] ?? '',
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 20),

                      // ชื่ออาหาร
                      Text(
                        foodData['name'] ?? 'ชื่ออาหารไม่พบ',
                        style: GoogleFonts.prompt(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      // ราคาอาหาร
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: Colors.green, size: 28),
                          Text(
                            '${foodData['price'] ?? 'ไม่ระบุ'} บาท',
                            style: GoogleFonts.prompt(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // กล่องรายละเอียดอาหาร
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.teal.shade50,
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'รายละเอียด:',
                                style: GoogleFonts.prompt(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade900,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                foodData['description'] ?? 'ไม่มีรายละเอียด',
                                style: GoogleFonts.prompt(
                                  fontSize: 18,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                    
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FoodApp()));
                     
                          },
                          icon: Icon(Icons.arrow_back_ios_outlined),
                          label: Text(
                            'ย้อนกลับ',
                            style: GoogleFonts.prompt(fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
