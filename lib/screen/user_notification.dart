import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seafood_app/screen/profile/profile.dart';

class CustomerNotificationsPage extends StatefulWidget {
  @override
  _CustomerNotificationsPageState createState() => _CustomerNotificationsPageState();
}

class _CustomerNotificationsPageState extends State<CustomerNotificationsPage> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserId();
  }

  // ดึง userId ของลูกค้าที่ล็อกอินอยู่
  Future<void> fetchCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  // ดึงการแจ้งเตือนจาก customer_notifications collection สำหรับลูกค้าที่ล็อกอินอยู่
  Stream<List<Map<String, dynamic>>> fetchCustomerNotifications() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('customer_notifications')
        .where('userId', isEqualTo: currentUserId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การแจ้งเตือนของคุณ', style: GoogleFonts.prompt(color: Colors.white)),
        backgroundColor: Colors.teal,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (context) => ProfilePage()));
        }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.teal.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: fetchCustomerNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('ไม่มีการแจ้งเตือน', style: GoogleFonts.prompt()));
            }

            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final message = notification['message'] ?? 'ไม่มีข้อความแจ้งเตือน';  // ตรวจสอบว่ามี message หรือไม่
                final timestamp = (notification['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();  // ตรวจสอบ timestamp

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.notifications, size: 40, color: Colors.teal),
                    title: Text(message, style: GoogleFonts.prompt(color: Colors.teal.shade800)),
                    subtitle: Text('วันที่: ${timestamp.toLocal()}',
                        style: TextStyle(color: Colors.grey.shade600)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
