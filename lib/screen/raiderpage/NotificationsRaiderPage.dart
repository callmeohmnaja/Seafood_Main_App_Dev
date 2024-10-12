import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seafood_app/screen/raiderpage/raider_dashboard.dart';

class NotificationsRaiderPage extends StatelessWidget {
  const NotificationsRaiderPage({super.key});

  // ฟังก์ชันสำหรับการดึงการแจ้งเตือนจาก Firestore โดยใช้ username ของไรเดอร์
  Stream<QuerySnapshot> _getNotificationsForRider(String username) {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('username', isEqualTo: username) // กรองการแจ้งเตือนตาม username
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    // ตรวจสอบว่ามีผู้ใช้ล็อกอินอยู่หรือไม่
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('การแจ้งเตือนจากร้านค้า'),
          backgroundColor: Colors.teal,
       
        ),
        body: Center(
          child: Text('กรุณาเข้าสู่ระบบก่อนดูการแจ้งเตือน'),
        ),
      );
    }

    // ดึง username ของไรเดอร์จาก Firestore
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('การแจ้งเตือนจากร้านค้า'),
              backgroundColor: Colors.teal,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('การแจ้งเตือนจากร้านค้า'),
              backgroundColor: Colors.teal,
             
            ),
            body: Center(child: Text('ไม่พบข้อมูลผู้ใช้')),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final username = userData['username'] ?? '';

        // แสดงการแจ้งเตือนสำหรับไรเดอร์ที่มี username นี้
        return Scaffold(
          appBar: AppBar(
            title: Text('การแจ้งเตือนจากร้านค้า'),
            backgroundColor: Colors.teal,
            leading: IconButton(onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => RaiderDashboard()));
            }, icon: Icon(Icons.arrow_back_ios)),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.tealAccent.shade100],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: _getNotificationsForRider(username),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('ไม่มีการแจ้งเตือน'));
                }

                final notifications = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notificationData =
                        notifications[index].data() as Map<String, dynamic>;
                    final restaurantName =
                        notificationData['restaurantName'] ?? 'ไม่พบชื่อร้าน';
                    final storeProfileImageUrl =
                        notificationData['restaurantProfileImageUrl'] ?? '';
                    final message = notificationData['message'] ?? 'ไม่มีข้อความ';
                    final timestamp =
                        notificationData['timestamp']?.toDate() ?? DateTime.now();

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: storeProfileImageUrl.isNotEmpty
                              ? NetworkImage(storeProfileImageUrl)
                              : null,
                          backgroundColor: Colors.grey[300],
                          child: storeProfileImageUrl.isEmpty
                              ? Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
                        title: Text('$username ได้รับการพิจารณาจากร้าน: $restaurantName'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message),
                            SizedBox(height: 4),
                            Text('เวลาที่แจ้งเตือน: ${timestamp.toLocal()}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
