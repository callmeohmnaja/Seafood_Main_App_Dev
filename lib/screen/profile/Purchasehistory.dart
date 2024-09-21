import 'package:flutter/material.dart';
import 'package:seafood_app/screen/profile/profile.dart';

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
        leading: IconButton(icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
        },),
        
      ),
      
    );
  }
}
