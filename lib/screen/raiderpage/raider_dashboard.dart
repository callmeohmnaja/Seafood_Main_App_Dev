import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seafood_app/screen/home.dart';
import 'package:seafood_app/screen/raiderpage/NotificationsRaiderPage.dart';
import 'package:seafood_app/screen/raiderpage/chatboradforraider.dart';
import 'package:seafood_app/screen/raiderpage/editprofileforraider.dart';
import 'package:seafood_app/screen/raiderpage/find_store_page.dart';

class RaiderDashboard extends StatefulWidget {
  const RaiderDashboard({super.key});

  @override
  State<RaiderDashboard> createState() => _RaiderDashboardState();
}

class _RaiderDashboardState extends State<RaiderDashboard> {
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
        title: Text(''),
        backgroundColor: Colors.teal,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.motorcycle)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent.shade100],
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
            String role = userData['role'] ?? 'ไม่ระบุ';
            String contactNumber = userData['contactNumber'] ?? 'ไม่ระบุ';

            return Column(
              children: <Widget>[
                _buildProfileHeader(username, role, contactNumber),
                Divider(),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      _buildMenuItem('ตรวจสอบร้าน', Icons.store, FindStorePage()),
                      _buildMenuItem('แจ้งเตือนการสมัครงาน', Icons.notifications, NotificationsRaiderPage()),
                      _buildMenuItem('แก้ไขโปรไฟล์', Icons.edit, Editprofileforraider()),
                      _buildMenuItem('Ku Chat', Icons.chat, ChatBoardPageforraider()),
                      _buildLogoutButton(),
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

  Widget _buildProfileHeader(String username, String role, String contactNumber) {
    return Container(
      padding: EdgeInsets.all(16),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text('บทบาท: $role', style: TextStyle(fontSize: 16, color: Colors.white)),
              Text('อีเมลของคุณคือ: ${auth.currentUser?.email ?? ''}', style: TextStyle(fontSize: 16, color: Colors.white)),
              Text('โทรศัพท์: $contactNumber', style: TextStyle(fontSize: 16, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(fontSize: 18, color: Colors.white)),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  Widget _buildLogoutButton() {
    return ListTile(
      leading: Icon(Icons.logout, color: Colors.red),
      title: Text('ออกจากระบบ', style: TextStyle(fontSize: 18, color: Colors.red)),
      onTap: () {
        auth.signOut().then((_) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        });
      },
    );
  }
}
