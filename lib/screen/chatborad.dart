import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: use_key_in_widget_constructors
class ChatBoardPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ChatBoardPageState createState() => _ChatBoardPageState();
}

class _ChatBoardPageState extends State<ChatBoardPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ฟังก์ชันสำหรับโพสต์ข้อความลง Firestore
  Future<void> _postMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return; // ไม่ส่งข้อความที่ว่างเปล่า
    }

    final user = _auth.currentUser;
    String username = 'Anonymous';
    String profileImageUrl = '';

    if (user != null) {
      // ดึงข้อมูลชื่อผู้ใช้และรูปโปรไฟล์จาก Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        username = userDoc['username'] ?? 'Anonymous';
        profileImageUrl = userDoc['profileImageUrl'] ?? '';
      } else if (user.displayName != null && user.displayName!.isNotEmpty) {
        username = user.displayName!;
      }

      await _firestore.collection('chat_messages').add({
        'text': _messageController.text,
        'createdAt': Timestamp.now(),
        'username': username,
        'profileImageUrl': profileImageUrl,
        'userId': user.uid,
      });

      _messageController.clear(); // ล้างฟิลด์ข้อความหลังจากโพสต์แล้ว
    }
  }

  // ฟังก์ชันสำหรับดึงข้อมูลข้อความแชทจาก Firestore
  Stream<QuerySnapshot> _getMessagesStream() {
    return _firestore
        .collection('chat_messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KU Chat!',style: GoogleFonts.prompt()),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getMessagesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('ยังไม่พบข้อความ',style: GoogleFonts.prompt(),));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final messageData = messages[index].data() as Map<String, dynamic>;
                    final messageText = messageData['text'] ?? '';
                    final messageSender = messageData['username'] ?? 'Unknown';
                    final messageTime = messageData['createdAt']?.toDate() ?? DateTime.now();
                    final profileImageUrl = messageData['profileImageUrl'] ?? '';

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : null,
                        child: profileImageUrl.isEmpty
                            ? Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                      title: Text(messageSender),
                      subtitle: Text(messageText),
                      trailing: Text(
                        '${messageTime.hour}:${messageTime.minute}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  // ฟังก์ชันสร้าง TextField สำหรับพิมพ์ข้อความและปุ่มส่งข้อความ
  Widget _buildMessageInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'พิมพ์ข้อความ...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blueAccent),
            onPressed: _postMessage,
          ),
        ],
      ),
    );
  }
}
