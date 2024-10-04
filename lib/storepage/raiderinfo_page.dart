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
        backgroundColor: Colors.orange[500],
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
      body: StreamBuilder<QuerySnapshot>(
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
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.0),
                  leading: profileImageUrl.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(profileImageUrl),
                          radius: 30,
                        )
                      : CircleAvatar(
                          child: Icon(Icons.person, size: 30),
                          backgroundColor: Colors.green[300],
                          radius: 30,
                        ),
                  title: Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'อีเมล: $email\nรถ: $vehicle',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  tileColor: Color.fromARGB(255, 241, 241, 241),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
