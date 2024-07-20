import 'package:flutter/material.dart';
import 'package:seafood_app/screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final auth = FirebaseAuth.instance;
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
              'อีเมลของคุณคือ' + auth.currentUser!.email.toString(), // แสดงอีเมลของผู้ใช้
              style: TextStyle (fontSize: 24),
            ),
            ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return HomeScreen();
                    }));
                  },
                  child: Text('ออกจากระบบ'))
                   ],
            
        ),
      ),
    );
  }
}