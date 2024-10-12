import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreNotificationsPage extends StatelessWidget {
  const StoreNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การแจ้งเตือนจากไรเดอร์'),
        backgroundColor: Colors.brown.shade50, // Dark brown for a rich look
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade50, Colors.brown.shade100, Colors.brown.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('store_notifications')
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
                final notificationData = notifications[index].data() as Map<String, dynamic>;
                final riderName = notificationData['riderName'] ?? 'ไม่พบชื่อไรเดอร์';
                final riderProfileImageUrl = notificationData['riderProfileImageUrl'] ?? '';
                final message = notificationData['message'] ?? 'ไม่มีข้อความ';
                final timestamp = notificationData['timestamp']?.toDate() ?? DateTime.now();

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.brown.shade200, // Light brown background
                      backgroundImage: riderProfileImageUrl.isNotEmpty
                          ? NetworkImage(riderProfileImageUrl)
                          : null,
                      child: riderProfileImageUrl.isEmpty
                          ? Icon(Icons.person, color: Colors.brown.shade700, size: 30)
                          : null,
                    ),
                    title: Text(
                      message,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade900, // Dark brown text for emphasis
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ไรเดอร์: $riderName',
                            style: TextStyle(
                              color: Colors.brown.shade700,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'เวลาที่แจ้งเตือน: ${timestamp.toLocal()}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
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