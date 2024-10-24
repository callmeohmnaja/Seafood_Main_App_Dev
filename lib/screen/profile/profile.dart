import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seafood_app/screen/addmoney_page.dart';
import 'package:seafood_app/screen/food_app.dart';
import 'package:seafood_app/screen/home.dart';
import 'dart:io';
import 'package:seafood_app/screen/profile/Purchasehistory.dart';
import 'package:seafood_app/screen/profile/editprofile_page.dart';
import 'package:seafood_app/screen/user_notification.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final picker = ImagePicker();

  String? profileImageUrl;
  double? userBalance;

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
          userBalance = userData['balance']?.toDouble() ?? 0.0;
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
        title: Text('โปรไฟล์ของฉัน', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => FoodApp()));
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: firestore.collection('users').doc(auth.currentUser?.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: TextStyle()));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('ไม่พบข้อมูลโปรไฟล์', style: TextStyle()));
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String username = userData['username'] ?? 'ไม่ระบุ';
            String role = userData['role'] ?? 'ไม่ระบุ';

            return ListView(
              padding: EdgeInsets.only(top: 100),
              children: <Widget>[
                _buildProfileHeader(username, role, userBalance),
                Divider(height: 40),
                _buildProfileOption('แก้ไขโปรไฟล์', Icons.edit, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditprofilePage()));
                }),
                _buildProfileOption('ออเดอร์ของฉัน', Icons.rotate_90_degrees_cw_outlined,() {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerNotificationsPage()));
                }),
                _buildProfileOption('ประวัติการสั่งซื้อ', Icons.history, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrderHistoryPage()));
                }),
                _buildProfileOption('เติมเงินเข้าระบบ', Icons.money, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddMoneyPage()));
                }),
                _buildProfileOption('ออกจากระบบ', Icons.logout, () {
                  auth.signOut().then((_) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  });
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String username, String role, double? balance) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Card(
        color: Colors.white.withOpacity(0.9),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueAccent,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.white,
                    backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
                    child: profileImageUrl == null ? Icon(Icons.camera_alt, size: 40, color: Colors.grey) : null,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ชื่อผู้ใช้: $username',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'ยอดเงินคงเหลือ: ${balance != null ? '${balance.toStringAsFixed(2)} บาท' : 'ไม่ระบุ'}',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'อีเมล: ${auth.currentUser?.email ?? ''}',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon, VoidCallback onTap) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
        onTap: onTap,
      ),
    );
  }
}
