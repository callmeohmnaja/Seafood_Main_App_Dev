import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seafood_app/storepage/raider_detailPage.dart';
import 'package:seafood_app/storepage/store_dashboard.dart';

class RaiderinfoPage extends StatelessWidget {
  const RaiderinfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ข้อมูลไรเดอร์"),
        backgroundColor: Colors.brown.shade50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StoreDashboard()),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade50, Colors.brown.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'ไรเดอร์')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('ไม่พบข้อมูลไรเดอร์'));
            }

            final documents = snapshot.data!.docs;

            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final data = documents[index].data() as Map<String, dynamic>;
                final email = data['email'] ?? 'ไม่มีข้อมูล';
                final username = data['username'] ?? 'ไม่มีข้อมูล';
                final vehicle = data['vehicle'] ?? 'ไม่มีข้อมูล';
                final profileImageUrl = data['profileImageUrl'] ?? '';

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    leading: profileImageUrl.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(profileImageUrl),
                            radius: 30,
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.brown.shade200,
                            radius: 30,
                            child: Icon(Icons.person, size: 30, color: Colors.brown.shade700),
                          ),
                    title: Text(
                      username,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown.shade800),
                    ),
                    subtitle: Text(
                      'อีเมล: $email\nรถ: $vehicle',
                      style: TextStyle(color: Colors.brown.shade600),
                    ),
                    tileColor: Colors.brown.shade50,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RaiderDetailPage(
                            raiderData: data,
                          ),
                        ),
                      );
                    },
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RaiderDetailPage(
                              raiderData: data,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown.shade600,
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'รายละเอียด',
                        style: TextStyle(color: Colors.white),
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
