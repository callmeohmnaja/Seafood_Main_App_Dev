import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderStorepage extends StatefulWidget {
  @override
  _OrderStorepageState createState() => _OrderStorepageState();
}

class _OrderStorepageState extends State<OrderStorepage> {
  String? currentRestaurantUsername;

  @override
  void initState() {
    super.initState();
    fetchRestaurantUsername();
  }

  Future<void> fetchRestaurantUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        currentRestaurantUsername = userDoc.data()?['username'];
      });
    }
  }

  Stream<List<Map<String, dynamic>>> fetchOrderNotifications() {
    if (currentRestaurantUsername == null) {
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('food_store_notifications')
        .where('username', isEqualTo: currentRestaurantUsername)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> sendResponseToCustomer(String userId, String message) async {
    await FirebaseFirestore.instance.collection('customer_notifications').add({
      'message': message,
      'userId': userId,
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การแจ้งเตือนออเดอร์', style: GoogleFonts.prompt(color: Colors.brown)),
        backgroundColor: Colors.brown.shade300,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade50, Colors.brown.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: fetchOrderNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('ไม่มีการแจ้งเตือนคำสั่งซื้อ', style: GoogleFonts.prompt()));
            }

            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final items = notification['items'] as List<dynamic>;
                final orderItems = items.map((item) => '${item['name']} (THB ${item['price'].toStringAsFixed(2)})').join(', ');
                final totalAmount = items.fold(0.0, (sum, item) => sum + (item['price'] as num));
                final phone = notification['phone'] ?? 'ไม่พบเบอร์โทรศัพท์';
                final address = notification['address'] ?? 'ไม่พบที่อยู่';
                final userId = notification['userId'];  // ดึง userId ของลูกค้า

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: notification['imageUrl'] != null && notification['imageUrl'].isNotEmpty
                          ? Image.network(
                              notification['imageUrl'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image, size: 60, color: Colors.grey),
                    ),
                    title: Text('คุณมีคำสั่งซื้อใหม่', style: GoogleFonts.prompt(color: Colors.brown)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('รายการ: $orderItems', style: TextStyle(color: Colors.brown.shade700)),
                        Text('ยอดรวม: THB ${totalAmount.toStringAsFixed(2)}', style: TextStyle(color: Colors.brown.shade600)),
                        Text('วันที่: ${(notification['timestamp'] as Timestamp).toDate().toString()}', style: TextStyle(color: Colors.brown.shade600)),
                        SizedBox(height: 8),
                        Text('โปรดติดต่อลูกค้าที่เบอร์: $phone', style: TextStyle(color: Colors.red.shade600)),
                        Text('ที่อยู่ในการจัดส่ง: $address', style: TextStyle(color: Colors.red.shade600)),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            sendResponseToCustomer(userId, 'ร้านค้าได้ยอมรับคำสั่งซื้อของคุณ');
                          },
                          child: Text('ยอมรับ', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            sendResponseToCustomer(userId, 'ร้านค้าได้ปฏิเสธคำสั่งซื้อของคุณ');
                          },
                          child: Text('ปฏิเสธ', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
