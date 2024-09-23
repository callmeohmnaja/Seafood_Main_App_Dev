import 'package:flutter/material.dart';
import 'package:seafood_app/screen/profile/profile.dart';

class Purchasehistory extends StatefulWidget {
  const Purchasehistory({super.key});

  @override
  State<Purchasehistory> createState() => _PurchasehistoryState();
}

class _PurchasehistoryState extends State<Purchasehistory> {
  // สร้างรายการตัวอย่างของประวัติการสั่งซื้อ
  final List<Map<String, dynamic>> purchaseHistory = [
    {
      "orderNumber": "12345",
      "date": "20 กันยายน 2024",
      "total": 150.0,
    },
    {
      "orderNumber": "67890",
      "date": "15 สิงหาคม 2024",
      "total": 200.0,
    },
    {
      "orderNumber": "54321",
      "date": "1 กรกฎาคม 2024",
      "total": 180.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("ประวัติการสั่งซื้อ(ตอนนี้ยังไม่ได้ดึงจาก db)"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          },
        ),
      ),
      body: ListView.builder(
        itemCount: purchaseHistory.length,
        itemBuilder: (context, index) {
          var order = purchaseHistory[index];
          return Card(
            margin: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: Icon(Icons.receipt, color: Colors.green),
              title: Text("คำสั่งซื้อ #${order['orderNumber']}"),
              subtitle: Text("วันที่: ${order['date']}"),
              trailing: Text("฿${order['total']}"),
            ),
          );
        },
      ),
    );
  }
}
