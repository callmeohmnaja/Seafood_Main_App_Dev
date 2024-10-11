import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seafood_app/screen/profile/profile.dart';

class CustomerOrderNotificationsPage extends StatelessWidget {
  const CustomerOrderNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การแจ้งเตือนสถานะออเดอร์'),
        backgroundColor: Colors.brown.shade800,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade200, Colors.brown.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('stateorder')
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
                final status = notificationData['status'] ?? 'ไม่มีข้อมูลสถานะ';
                final restaurantName = notificationData['restaurantName'] ?? 'ร้านอาหารไม่ทราบชื่อ';
                final restaurantProfileImageUrl = notificationData['restaurantProfileImageUrl'] ?? '';
                final items = notificationData['items'] as List<dynamic>? ?? [];
                final timestamp = notificationData['timestamp']?.toDate() ?? DateTime.now();

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    leading: restaurantProfileImageUrl.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(restaurantProfileImageUrl),
                            radius: 25,
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.brown.shade100,
                            child: Icon(Icons.store, color: Colors.brown),
                          ),
                    title: Text(
                      'สถานะออเดอร์: $status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade900,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ร้าน: $restaurantName'),
                        Text('รายการอาหาร:'),
                        ...items.map((item) => Text('- ${item['name']}')).toList(),
                        Text(
                          'เวลาที่แจ้งเตือน: ${timestamp.toLocal()}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
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
