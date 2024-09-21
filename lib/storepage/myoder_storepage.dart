import 'package:flutter/material.dart';
import 'package:seafood_app/storepage/store_dashboard.dart';

class MyoderStorepage extends StatelessWidget {
  const MyoderStorepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('ออเดอร์ของฉัน'),
          leading: (IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StoreDashboard()));
              },
              icon: Icon(Icons.arrow_back)))),
    );
  }
}
