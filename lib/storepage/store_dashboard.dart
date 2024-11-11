import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seafood_app/screen/home.dart';
import 'package:seafood_app/storepage/ChatForStorePage.dart';
import 'package:seafood_app/storepage/add_menu_page.dart';
import 'package:seafood_app/storepage/edit_or_delete_menu_page.dart';
import 'package:seafood_app/storepage/editstore_page.dart';
import 'package:seafood_app/storepage/order_storepage.dart';
import 'package:seafood_app/storepage/raiderinfo_page.dart';
import 'package:seafood_app/storepage/showmoney.dart';
import 'package:seafood_app/storepage/test.dart';

class StoreDashboard extends StatefulWidget {
  const StoreDashboard({super.key});

  @override
  _StoreDashboardState createState() => _StoreDashboardState();
}

class _StoreDashboardState extends State<StoreDashboard> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final picker = ImagePicker();

  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = auth.currentUser;
    if (user != null) {
      final doc = await firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          var userData = doc.data() as Map<String, dynamic>;
          profileImageUrl = userData['profileImageUrl'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _uploadImage(imageFile);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        String fileName = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageRef = storage.ref().child('profile_images').child(fileName);
        UploadTask uploadTask = storageRef.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        await firestore.collection('users').doc(user.uid).update({
          'profileImageUrl': downloadUrl,
        });

        setState(() {
          profileImageUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile image updated!')),
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จัดการร้านค้า'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        backgroundColor: Colors.brown.shade100,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade100, Colors.brown.shade200, Colors.brown.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: firestore.collection('users').doc(auth.currentUser?.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('ไม่พบโปรไฟล์'));
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String username = userData['username'] ?? 'ไม่ระบุ';
            String balance = userData['balance'] ?.toString() ?? 'ไม่ระบุ';
            String phone = userData['phone'] ?? 'ไม่ระบุ';

            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          child: profileImageUrl != null
                              ? CircleAvatar(
                                  radius: 38,
                                  backgroundImage: NetworkImage(profileImageUrl!),
                                )
                              : Icon(Icons.camera_alt, size: 40, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ชื่อผู้ใช้: $username',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown.shade800),
                          ),
                          Text('จํานวนเงิน: $balance', style: TextStyle(fontSize: 16, color: Colors.black87)),
                          Text('อีเมล: ${auth.currentUser?.email ?? ''}', style: TextStyle(fontSize: 16, color: Colors.black87)),
                          Text('โทรศัพท์: $phone', style: TextStyle(fontSize: 16, color: Colors.black87)),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.brown.shade300),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    children: <Widget>[
                      _buildStyledMenuItem('แจ้งเตือนคำสั่งซื้อใหม่', OrderStorepage()),
                      _buildStyledMenuItem('แก้ไขข้อมูลร้านค้า', EditstorePage()),
                      _buildStyledMenuItem('เพิ่มรายการเมนูอาหาร', AddMenuPage()),
                      _buildStyledMenuItem('แก้ไขหรือลบเมนู', EditOrDeleteMenuPage()),
                      _buildStyledMenuItem('Ku Chat', Chatforstorepage()),
                      _buildStyledMenuItem('ค้นหาไรเดอร์', RaiderinfoPage()),
                      _buildStyledMenuItem('รายได้ทั้งหมดของฉัน', Showmoney()),
                       _buildStyledMenuItem('test',SalesReportPage(userId: '')),
                      _buildStyledLogoutButton(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStyledMenuItem(String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown.shade800),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.brown.shade800),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          auth.signOut().then((_) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          });
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.brown.shade600,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ออกจากระบบ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Icon(Icons.exit_to_app, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
