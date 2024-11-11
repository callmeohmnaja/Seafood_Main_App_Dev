import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seafood_app/storepage/store_dashboard.dart';

class Showmoney extends StatefulWidget {
  const Showmoney({super.key});

  @override
  State<Showmoney> createState() => _ShowmoneyState();
}

class _ShowmoneyState extends State<Showmoney> {
  double storeBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchStoreBalance();
  }

  Future<void> _fetchStoreBalance() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          storeBalance = (userDoc['balance'] ?? 0.0).toDouble();
        });
      }
    } catch (e) {
      print('Error fetching store balance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายได้ทั้งหมดของคุณ"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StoreDashboard()),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'รายได้ของคุณ:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '${storeBalance.toStringAsFixed(2)} บาท',
              style: TextStyle(fontSize: 30, color: Colors.green, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _fetchStoreBalance,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: Colors.brown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'รีเฟรชรายได้',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
