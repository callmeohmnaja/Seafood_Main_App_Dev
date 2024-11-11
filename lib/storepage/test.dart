import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesReportPage extends StatelessWidget {
  final String userId;

  SalesReportPage({required this.userId});

  Future<double> _getTodaySales() async {
    // DateTime now = DateTime.now();
    // DateTime startOfDay = DateTime(now.year, now.month, now.day);
    // DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('food_store_notifications')
        .where('username', isEqualTo: userId)
        // .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
        // .where('createdAt', isLessThanOrEqualTo: endOfDay)
        .get();

    double totalSales = 0;
    for (var doc in querySnapshot.docs) {
      totalSales += (doc['totalAmount'] ?? 0).toDouble();
    }

    return totalSales;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตรวจสอบยอดขาย'),
        backgroundColor: Colors.brown.shade50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade50, Colors.brown.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<double>(
            future: _getTodaySales(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'เกิดข้อผิดพลาดในการดึงข้อมูลยอดขาย',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.attach_money, size: 60, color: Colors.green),
                      SizedBox(height: 16),
                      Card(
                        color: Colors.brown.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'ยอดขายวันนี้',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                '${snapshot.data!.toStringAsFixed(2)} บาท',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown.shade800,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                DateFormat('dd MMM yyyy')
                                    .format(DateTime.now()),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.brown.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                );
              }
            },
          ),
        ),
      ),
    );
  }
}