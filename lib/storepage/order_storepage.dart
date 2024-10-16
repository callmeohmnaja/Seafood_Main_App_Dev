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
          'docId': doc.id,
          'items': items,
        };
      }).toList();
    });
  }

  Future<void> sendResponseToCustomer(String userId, String message, String orderId) async {
    await FirebaseFirestore.instance.collection('customer_notifications').add({
      'message': message,
      'userId': userId,
      'timestamp': Timestamp.now(),
      'username': currentRestaurantUsername,
    });

    await FirebaseFirestore.instance.collection('food_store_notifications').doc(orderId).delete();
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
                  final orderId = notification['docId'];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 6,
                    shadowColor: Colors.brown.shade700.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.fastfood, color: Colors.brown.shade700, size: 30),
                              SizedBox(width: 10),
                              Text(
                                'คุณมีคำสั่งซื้อใหม่',
                                style: GoogleFonts.prompt(
                                  color: Colors.brown.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Divider(color: Colors.brown.shade400),
                          SizedBox(height: 8),
                          Text('รายการ: $orderItems', style: TextStyle(color: Colors.brown.shade600)),
                          Text('ยอดรวม: THB ${totalAmount.toStringAsFixed(2)}', style: TextStyle(color: Colors.brown.shade600)),
                          Text('วันที่: ${(notification['timestamp'] as Timestamp).toDate().toString()}', style: TextStyle(color: Colors.brown.shade600)),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.phone, color: Colors.red.shade600, size: 20),
                              SizedBox(width: 5),
                              Text('เบอร์โทร: $phone', style: TextStyle(color: Colors.red.shade600)),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.red.shade600, size: 20),
                              SizedBox(width: 5),
                              Text('ที่อยู่: $address', style: TextStyle(color: Colors.red.shade600)),
                            ],
                          ),
                          SizedBox(height: 8),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // จำนวนคอลัมน์ของกริด
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, itemIndex) {
                              final item = items[itemIndex];
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: item['imageUrl'] != null && item['imageUrl'].isNotEmpty
                                    ? Image.network(
                                        item['imageUrl'],
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(Icons.image, size: 60, color: Colors.grey),
                              );
                            },
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  sendResponseToCustomer(userId, 'ร้าน $currentRestaurantUsername ได้ยอมรับคำสั่งซื้อของคุณสำหรับ: $orderItems', orderId);
                                },
                                icon: Icon(Icons.check_circle, color: Colors.white),
                                label: Text('ยอมรับ'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: () {
                                  sendResponseToCustomer(userId, 'ร้าน $currentRestaurantUsername ได้ปฏิเสธคำสั่งซื้อของคุณ', orderId);
                                },
                                icon: Icon(Icons.cancel, color: Colors.white),
                                label: Text('ปฏิเสธ'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
