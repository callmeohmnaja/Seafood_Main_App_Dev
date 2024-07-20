import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('images/rick.jpg'), // เปลี่ยนเป็นตำแหน่งรูปโปรไฟล์ของคุณ
            ),
            SizedBox(height: 20),
            Text(
              'example@email.com', // แสดงอีเมลของผู้ใช้
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}