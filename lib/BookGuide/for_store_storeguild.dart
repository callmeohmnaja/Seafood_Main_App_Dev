import 'package:flutter/material.dart';
import 'package:seafood_app/storepage/store_dashboard.dart';

class ForStoreStoreguild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "คู่มือการเปิดร้านอาหาร",
          style: TextStyle(fontSize: 20, color: Colors.green),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'คู่มือการเปิดร้านอาหาร',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'กรุณาใส่ข้อมูลเกี่ยวกับวิธีการชําระเงินที่นี่',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StoreDashboard()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Background color
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: Text(
                'หน้าหลัก',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
