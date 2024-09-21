import 'package:flutter/material.dart';
import 'package:seafood_app/storepage/store_dashboard.dart';

// ignore: use_key_in_widget_constructors
class ForStoreStoreguild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("คู่มือการเปิดร้านอาหาร",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'คู่มือการเปิดร้านอาหาร',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              'สำหรับคู่มือร้านอาหาร ประกอบไปด้วย 5 ตัวเลือก (Option):\n\n'
              '1. เพิ่มเมนูอาหาร: ร้านค้าสามารถเพิ่มเมนูอาหารตามที่ต้องการได้\n'
              '2. แก้ไขหรือลบเมนูอาหาร\n'
              '3. ไรเดอร์ที่ลงทะเบียน: สามารถดูจำนวนไรเดอร์ที่ลงทะเบียนพร้อมข้อมูลเบื้องต้น เช่น รถ เบอร์ติดต่อ\n'
              '4. คู่มือร้านอาหาร\n'
              '5. ออกจากระบบ',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StoreDashboard()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Background color
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'หน้าหลัก',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
