import 'package:flutter/material.dart';
import 'package:seafood_app/storepage/add_menu_page.dart';
import 'package:seafood_app/storepage/edit_or_delete_menu_page.dart';

class StoreDashboard extends StatefulWidget {
  @override
  _StoreDashboardState createState() => _StoreDashboardState();
}

class _StoreDashboardState extends State<StoreDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMenuPage()),
                );
              },
              child: Text('เพิ่มเมนูอาหาร'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditOrDeleteMenuPage()),
                );
              },
              child: Text('แก้ไขหรือลบเมนูอาหาร'),
            ),
          ],
        ),
      ),
    );
  }
}
