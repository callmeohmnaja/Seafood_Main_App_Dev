import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seafood_app/storepage/store_dashboard.dart';

class OrderStorepage extends StatefulWidget {
  const OrderStorepage({super.key});

  @override
  _OrderStorepageState createState() => _OrderStorepageState();
}

class _OrderStorepageState extends State<OrderStorepage> {
  String? currentRestaurantUsername;
  String currentStatus = 'กำลังทำเมนู'; // กำหนดค่าเริ่มต้นของสถานะให้ตรงกับ DropdownMenuItem

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
        String status = data['status'] ?? 'กำลังทำเมนู'; // กำหนดค่าเริ่มต้นสำหรับสถานะ

        // ตรวจสอบให้แน่ใจว่าสถานะตรงกับค่าที่มีใน DropdownMenuItem
        if (!['กำลังทำเมนู', 'กำลังจัดส่ง', 'จัดส่งสำเร็จ', 'ปฏิเสธคำสั่งซื้อ'].contains(status)) {
          status = 'กำลังทำเมนู';
        }

        return {
          'address': data['address'],
          'phone': data['phone'],
          'timestamp': data['timestamp'],
          'userId': data['userId'],
          'docId': doc.id,
          'items': items,
          'status': status, // สถานะที่ถูกต้อง
        };
      }).toList();
    });
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    // อัปเดตสถานะใน food_store_notifications
    await FirebaseFirestore.instance.collection('food_store_notifications').doc(orderId).update({
      'status': newStatus,
      'timestamp': Timestamp.now(),
    });

    // ตรวจสอบว่ามี customer_notifications สำหรับ order นี้แล้วหรือยัง
    final existingNotification = await FirebaseFirestore.instance
        .collection('customer_notifications')
        .where('orderId', isEqualTo: orderId)
        .get();

    // ถ้าไม่มี ให้สร้างใหม่
    if (existingNotification.docs.isEmpty) {
      final foodStoreDoc = await FirebaseFirestore.instance.collection('food_store_notifications').doc(orderId).get();
      final foodStoreData = foodStoreDoc.data();

      if (foodStoreData != null) {
        await FirebaseFirestore.instance.collection('customer_notifications').add({
          'orderId': orderId,
          'userId': foodStoreData['userId'], // userId ของลูกค้า
          'status': newStatus,
          'items': foodStoreData['items'],
          'username': currentRestaurantUsername,
          'message': 'สถานะออเดอร์ของคุณถูกเปลี่ยนเป็น $newStatus',
          'timestamp': Timestamp.now(),
        });
      }
    } else {
      // ถ้ามีแล้ว ให้แค่อัปเดตสถานะ
      for (var doc in existingNotification.docs) {
        await doc.reference.update({
          'status': newStatus,
          'timestamp': Timestamp.now(),
          'message': 'สถานะออเดอร์ของคุณถูกเปลี่ยนเป็น $newStatus',
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การแจ้งเตือนออเดอร์', style: TextStyle(color: Colors.black)),
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
              return Center(child: Text('ไม่มีการแจ้งเตือนคำสั่งซื้อ', style: TextStyle()));
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
                  final orderId = notification['docId'];
                  currentStatus = notification['status']; // อัปเดตค่า currentStatus จากข้อมูล Firestore

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
                                style: TextStyle(
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
                              DropdownButton<String>(
                                value: currentStatus, // ใช้สถานะที่ถูกต้อง
                                items: [
                                  DropdownMenuItem(
                                    value: 'กำลังทำเมนู',
                                    child: Text('กำลังทำเมนู'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'กำลังจัดส่ง',
                                    child: Text('กำลังจัดส่ง'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'จัดส่งสำเร็จ',
                                    child: Text('จัดส่งสำเร็จ'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'ปฏิเสธคำสั่งซื้อ',
                                    child: Text('ปฏิเสธคำสั่งซื้อ'),
                                  ),
                                ],
                                onChanged: (newStatus) {
                                  setState(() {
                                    currentStatus = newStatus!;
                                  });
                                  updateOrderStatus(orderId, newStatus!);
                                },
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
