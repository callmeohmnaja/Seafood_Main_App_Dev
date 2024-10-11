import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seafood_app/screen/raiderpage/raider_dashboard.dart';

class ChatBoardPageforraider extends StatefulWidget {
  const ChatBoardPageforraider({super.key});

  @override
  State<ChatBoardPageforraider> createState() => _ChatBoardPageState();
}

class _ChatBoardPageState extends State<ChatBoardPageforraider> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _postMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return; // ไม่ส่งข้อความที่ว่างเปล่า
    }

    final user = _auth.currentUser;
    String username = 'Anonymous';
    String profileImageUrl = '';

    if (user != null) {
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
        title: Text('KU Chat!'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RaiderDashboard()),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
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
                    return Center(child: Text('ยังไม่พบข้อความ'));
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

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
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
                            title: Text(
                              messageSender,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[800]),
                            ),
                            subtitle: Text(messageText),
                            trailing: Text(
                              '${messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
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
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.tealAccent.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                hintText: 'พิมพ์ข้อความ...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blueAccent,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _postMessage,
            ),
          ),
        ],
      ),
    );
  }
}
