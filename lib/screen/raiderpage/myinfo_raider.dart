import 'package:flutter/material.dart';

import 'package:seafood_app/screen/raiderpage/raider_dashboard.dart';

class MyinfoRaider extends StatelessWidget {
  const MyinfoRaider({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ข้อมูลของฉัน'),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RaiderDashboard()));
            },
          ),
        ),
       //add background color ทีหลัง หาสีไม่ได้ ในส่วนของ body
        backgroundColor: Color.fromARGB(255, 216, 230, 139),
        body:Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green[700]!, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0,5),
                        ),
                      ],
                      ),
                 //add Image form firebase
                ),
              ),
              SizedBox(child: Text('ชื่อของคุณคือ',style: TextStyle(fontSize: 20),),
              ),
              SizedBox(child: Text('คิดไม่ออกเว้ยๆๆๆ',style: TextStyle(fontSize: 20)),
              ),
              
            ],
          ),
        )
        );
  }
}
