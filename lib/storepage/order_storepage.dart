import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seafood_app/storepage/store_dashboard.dart';

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
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final items = List<Map<String, dynamic>>.from(data['items']);

        return {
          'address': data['address'],
          'phone': data['phone'],
          'timestamp': data['timestamp'],
          'userId': data['userId'],
          'items': items,
        };
      }).toList();
    });
  }

  Future<void> sendResponseToCustomer(String userId, String message) async {
    await FirebaseFirestore.instance.collection('customer_notifications').add({
      'message': message,
      'userId': userId,
      'timestamp': Timestamp.now(),
      'username': currentRestaurantUsername,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การแจ้งเตือนออเดอร์', style: GoogleFonts.prompt(color: Colors.black)),
        backgroundColor: Colors.brown.shade100,
        leading: IconButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => StoreDashboard()));
        }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade100, Colors.brown.shade300],
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

                if (items.isNotEmpty) {
                  final orderItems = items.map((item) {
                    return '${item['name']} (THB ${item['price'].toStringAsFixed(2)})';
                  }).join(', ');

                  final totalAmount = items.fold(0.0, (sum, item) => sum + (item['price'] as num));
                  final phone = notification['phone'] ?? 'ไม่พบเบอร์โทรศัพท์';
                  final address = notification['address'] ?? 'ไม่พบที่อยู่';
                  final userId = notification['userId'];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 6,
                    shadowColor: Colors.brown.shade700.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: items[0]['imageUrl'] != null && items[0]['imageUrl'].isNotEmpty
                              ? Image.network(
                                  items[0]['imageUrl'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image, size: 60, color: Colors.grey),
                        ),
                        title: Text(
                          'คุณมีคำสั่งซื้อใหม่',
                          style: GoogleFonts.prompt(
                              color: Colors.brown.shade700, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text('รายการ: $orderItems', style: TextStyle(color: Colors.brown.shade600)),
                            Text('ยอดรวม: THB ${totalAmount.toStringAsFixed(2)}', style: TextStyle(color: Colors.brown.shade600)),
                            Text('วันที่: ${(notification['timestamp'] as Timestamp).toDate().toString()}', style: TextStyle(color: Colors.brown.shade600)),
                            SizedBox(height: 8),
                            Text('โปรดติดต่อลูกค้าที่เบอร์: $phone', style: TextStyle(color: Colors.red.shade600)),
                            Text('ที่อยู่ในการจัดส่ง: $address', style: TextStyle(color: Colors.red.shade600)),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check_circle, color: Colors.green, size: 30),
                              onPressed: () {
                                sendResponseToCustomer(userId, 'ร้านค้าได้ยอมรับคำสั่งซื้อของคุณ');
                              },
                              tooltip: 'ยอมรับ',
                            ),
                            IconButton(
                              icon: Icon(Icons.cancel, color: Colors.red, size: 30),
                              onPressed: () {
                                sendResponseToCustomer(userId, 'ร้านค้าได้ปฏิเสธคำสั่งซื้อของคุณ');
                              },
                              tooltip: 'ปฏิเสธ',
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: Text('ไม่พบรายการสั่งซื้อ'));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
