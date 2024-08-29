import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:seafood_app/screen/profile/editprofile_page.dart';
import 'package:seafood_app/screen/home.dart'; // For File

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        String fileName =
            '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageRef =
            storage.ref().child('profile_images').child(fileName);
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
        title: Text('โปรไฟล์'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            // Add other drawer items here...
          ],
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: firestore.collection('users').doc(auth.currentUser?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('โปรไฟล์ไม่พบ'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String username = userData['username'] ?? 'ไม่ระบุ';
          String role = userData['role'] ?? 'ไม่ระบุ';

          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[
                            300], // Background color if no image is present
                        child: profileImageUrl != null
                            ? CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(profileImageUrl!),
                              )
                            : Icon(Icons.camera_alt,
                                size: 40,
                                color:
                                    Colors.white), // Icon for uploading image
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ชื่อผู้ใช้: $username',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'บทบาท: $role',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'อีเมลของคุณคือ: ${auth.currentUser?.email ?? ''}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      title: Text('แก้ไขโปรไฟล์'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditprofilePage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: Text('การตั้งค่าบัญชี'),
                      onTap: () {
                        // Navigate to account settings page if needed
                      },
                    ),
                    ListTile(
                      title: Text('ประวัติการสั่งซื้อ'),
                      onTap: () {
                        // Navigate to order history page if needed
                      },
                    ),
                    ListTile(
                      title: Text('ออกจากระบบ'),
                      onTap: () {
                        auth.signOut().then((_) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
