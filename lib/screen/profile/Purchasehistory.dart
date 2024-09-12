import 'package:flutter/material.dart';

class Purchasehistory extends StatefulWidget {
  const Purchasehistory({super.key});

  @override
  State<Purchasehistory> createState() => _PurchasehistoryState();
}

class _PurchasehistoryState extends State<Purchasehistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ประวัติการสั่งซื้อ"),
      ),
    );
  }
}
