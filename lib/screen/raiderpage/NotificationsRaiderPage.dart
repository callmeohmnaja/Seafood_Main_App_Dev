import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsRaiderPage extends StatelessWidget {
  const NotificationsRaiderPage({super.key});

  // Function to send a notification from the rider to the store
  Future<void> _sendNotificationToStore(
      BuildContext context, String storeId, bool isAccepted) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final userData = userDoc.data() as Map<String, dynamic>?;
        final riderName = userData?['username'] ?? 'ไม่ทราบชื่อไรเดอร์';
        final riderProfileImageUrl = userData?['profileImageUrl'] ?? '';

        String message = isAccepted
            ? 'ไรเดอร์ได้กดยอมรับคำเชิญของคุณ'
            : 'ไรเดอร์ได้ปฏิเสธคำเชิญของคุณ';

        await FirebaseFirestore.instance.collection('store_notifications').add({
          'message': message,
          'riderId': user.uid,
          'riderName': riderName,
          'riderProfileImageUrl': riderProfileImageUrl,
          'storeId': storeId,
          'timestamp': Timestamp.now(),
        });

        // Check if the widget is still mounted before displaying the SnackBar
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('การแจ้งเตือนได้ถูกส่งไปยังร้านค้าแล้ว!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการส่งการแจ้งเตือนไปยังร้านค้า: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การแจ้งเตือนจากร้านค้า'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
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
              final storeId = notificationData['storeId'] ?? '';
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
                  title: Text('คุณได้รับการพิจารณาจากร้าน: $restaurantName'),
                  subtitle: Text(
                      'โปรดรอการติดต่อ\nเวลาที่แจ้งเตือน: ${timestamp.toLocal()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          _sendNotificationToStore(
                              context, storeId, false); // Decline request
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          _sendNotificationToStore(
                              context, storeId, true); // Accept request
                          notifications[index].reference.delete(); // Remove notification
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
