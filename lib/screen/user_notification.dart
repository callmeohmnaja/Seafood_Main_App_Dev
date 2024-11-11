import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seafood_app/screen/profile/profile.dart';

class CustomerNotificationsPage extends StatefulWidget {
  const CustomerNotificationsPage({super.key});

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
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final items = List<Map<String, dynamic>>.from(data['items'] ?? []);
        return {
          'message': data['message'],
          'username': data['username'] ?? 'ไม่ทราบชื่อร้าน',
          'items': items,
          'timestamp': data['timestamp'],
          'status': data['status'] ?? 'ไม่มีสถานะ', 
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สถานะออเดอร์ของคุณ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
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
              return Center(child: Text('ไม่มีการแจ้งเตือน', style: TextStyle()));
            }

            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final message = notification['message'] ?? 'ไม่มีข้อความแจ้งเตือน';
                final restaurantName = notification['username'] ?? 'ไม่ทราบชื่อร้าน';
                final items = notification['items'] as List<dynamic>;
                final timestamp = (notification['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();

                // สร้างรายการอาหารเป็น String
                final orderItems = items.map((item) {
                  return '${item['name']} (THB ${item['price'].toStringAsFixed(2)})';
                }).join(', ');

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.notifications, size: 40, color: Colors.teal),
                    title: Text('ร้าน: $restaurantName', style: TextStyle(color: Colors.teal.shade800)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('รายการอาหาร: $orderItems', style: TextStyle()),
                        Text('ข้อความ: $message', style: TextStyle()),
                        Text('สถานะ: ${notification['status']}', style: TextStyle(color: Colors.teal.shade600)), // แสดงสถานะ
                        Text('วันที่: ${timestamp.toLocal()}', style: TextStyle(color: Colors.grey.shade600)),
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
  }
}
