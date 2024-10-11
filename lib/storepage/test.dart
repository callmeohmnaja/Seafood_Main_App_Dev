import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreOrderManagementPage extends StatelessWidget {
  const StoreOrderManagementPage({super.key});

  // Function to update the order status and send notification to the customer
  Future<void> _updateOrderStatus(
      BuildContext context, String orderId, String userId, bool isAccepted, String restaurantName, String restaurantProfileImageUrl, List items) async {
    try {
      String statusMessage = isAccepted
          ? 'ร้านค้ายอมรับออเดอร์ของคุณแล้ว'
          : 'ร้านค้าปฏิเสธออเดอร์ของคุณ';

      // Check if the order document exists
      DocumentSnapshot orderDoc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();

      if (!orderDoc.exists) {
        // If the order doesn't exist, display an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ไม่พบออเดอร์ที่ต้องการอัปเดต'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Update the order status in the order document
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': isAccepted ? 'Accepted' : 'Rejected',
      });

      // Send a notification to the customer about the order status
      await FirebaseFirestore.instance.collection('food_store_notifications').add({
        'userId': userId,
        'orderId': orderId,
        'message': statusMessage,
        'restaurantName': restaurantName,
        'restaurantProfileImageUrl': restaurantProfileImageUrl,
        'items': items,
        'timestamp': Timestamp.now(),
      });

      // Save the order status in the new stateorder collection
      await FirebaseFirestore.instance.collection('stateorder').doc(orderId).set({
        'userId': userId,
        'orderId': orderId,
        'status': isAccepted ? 'Accepted' : 'Rejected',
        'restaurantName': restaurantName,
        'restaurantProfileImageUrl': restaurantProfileImageUrl,
        'items': items,
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAccepted ? 'ออเดอร์ได้รับการยอมรับ' : 'ออเดอร์ถูกปฏิเสธ'),
          backgroundColor: isAccepted ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      print('Error updating order status: $e'); // Improved error logging

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาดในการอัปเดตสถานะออเดอร์: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การจัดการออเดอร์'),
        backgroundColor: Colors.brown.shade800,
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
              .collection('orders')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('ไม่มีออเดอร์ที่ต้องจัดการ'));
            }

            final orders = snapshot.data!.docs;

            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final orderData = orders[index].data() as Map<String, dynamic>;
                final orderId = orders[index].id;
                final userId = orderData['userId'] ?? '';
                final items = orderData['items'] as List<dynamic>;
                final totalAmount = orderData['totalAmount'] ?? 0.0;
                final status = orderData['status'] ?? 'Pending';
                final restaurantName = orderData['restaurantName'] ?? 'ร้านอาหารไม่ทราบชื่อ';
                final restaurantProfileImageUrl = orderData['restaurantProfileImageUrl'] ?? '';

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: ListTile(
                    title: Text(
                      'ออเดอร์ #$orderId',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade900,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('รายการอาหาร:'),
                        ...items.map((item) => Text('- ${item['name']} (฿${item['price']})')).toList(),
                        SizedBox(height: 5),
                        Text('ยอดรวม: ฿$totalAmount'),
                        Text('สถานะ: $status'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            _updateOrderStatus(context, orderId, userId, true, restaurantName, restaurantProfileImageUrl, items);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            _updateOrderStatus(context, orderId, userId, false, restaurantName, restaurantProfileImageUrl, items);
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
