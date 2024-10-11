import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreOrderNotificationsPage extends StatelessWidget {
  const StoreOrderNotificationsPage({super.key});

  Future<void> _updateOrderStatus(BuildContext context, String orderId, String userId, bool isAccepted) async {
    try {
      String statusMessage = isAccepted ? 'ร้านค้ายอมรับออเดอร์ของคุณแล้ว' : 'ร้านค้าปฏิเสธออเดอร์ของคุณ';
      
      // Update the order status in the order document
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': isAccepted ? 'Accepted' : 'Rejected',
      });

      // Send a notification to the customer about the order status using food_store_notifications collection
      await FirebaseFirestore.instance.collection('food_store_notifications').add({
        'userId': userId,
        'orderId': orderId,
        'message': statusMessage,
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAccepted ? 'ออเดอร์ได้รับการยอมรับ' : 'ออเดอร์ถูกปฏิเสธ'),
          backgroundColor: isAccepted ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาดในการอัปเดตสถานะออเดอร์'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การแจ้งเตือนคำสั่งซื้อใหม่'),
        backgroundColor: Colors.brown.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade200, Colors.brown.shade400, Colors.brown.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('food_store_notifications')
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
              return Center(child: Text('ไม่มีการแจ้งเตือนคำสั่งซื้อ'));
            }

            final notifications = snapshot.data!.docs;

            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notificationData = notifications[index].data() as Map<String, dynamic>;
                final message = notificationData['message'] ?? 'ไม่มีข้อความ';
                final items = (notificationData['items'] as List<dynamic>?)
                    ?.map((item) => '${item['name']} - ฿${item['price']}')
                    .join(', ') ?? 'ไม่มีรายการ';
                final timestamp = notificationData['timestamp']?.toDate() ?? DateTime.now();
                final orderId = notificationData['orderId'] ?? '';
                final userId = notificationData['userId'] ?? '';

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.receipt_long, color: Colors.brown.shade800, size: 40),
                    title: Text(
                      message,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade800,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'รายการ: $items',
                            style: TextStyle(
                              color: Colors.grey[800],
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            _updateOrderStatus(context, orderId, userId, false); // Reject order
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            _updateOrderStatus(context, orderId, userId, true); // Accept order
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
      ),
    );
  }
}
