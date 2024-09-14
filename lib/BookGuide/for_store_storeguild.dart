import 'package:flutter/material.dart';
import 'package:seafood_app/storepage/store_dashboard.dart';

// ignore: use_key_in_widget_constructors
class ForStoreStoreguild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("คู่มือการเปิดร้านอาหาร",
            style: TextStyle(fontSize: 20, color: Colors.green)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => StoreDashboard()));
          },
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
                  'สําหรับคู่มือร้านอาหาร ประกอบไปด้วย 5 ตัวเลือก (Option) 1.เพิ่มเมนูอาหารร้านค้าสามารถเพิ่มเมนูอาหารตามที่ต้องการได้ \n 2.แก้ไขหรือลบมนูอาหาร 3.ไรเดอร์ที่ลงทะเบียน ',
                  style: TextStyle(fontSize: 18),
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
