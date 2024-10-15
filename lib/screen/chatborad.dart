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

  Future<void> _postMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
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

      _messageController.clear();
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
        title: Text('KU Chat!', style: GoogleFonts.prompt(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                    return Center(child: Text('ยังไม่พบข้อความ', style: GoogleFonts.prompt(fontSize: 16)));
                  }

                  final messages = snapshot.data!.docs;
                  final currentUser = _auth.currentUser;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final messageData = messages[index].data() as Map<String, dynamic>;
                      final messageText = messageData['text'] ?? '';
                      final messageSender = messageData['username'] ?? 'Unknown';
                      final messageTime = messageData['createdAt']?.toDate() ?? DateTime.now();
                      final profileImageUrl = messageData['profileImageUrl'] ?? '';
                      final isCurrentUser = messageData['userId'] == currentUser?.uid;

                      return Align(
                        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          child: Row(
                            mainAxisAlignment: isCurrentUser
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isCurrentUser)
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.teal.shade300,
                                  backgroundImage: profileImageUrl.isNotEmpty
                                      ? NetworkImage(profileImageUrl)
                                      : null,
                                  child: profileImageUrl.isEmpty
                                      ? Icon(Icons.person, color: Colors.white)
                                      : null,
                                ),
                              if (!isCurrentUser) SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: isCurrentUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      messageSender,
                                      style: GoogleFonts.prompt(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal.shade900,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Material(
                                      elevation: 3,
                                      borderRadius: BorderRadius.circular(8),
                                      color: isCurrentUser ? Colors.teal.shade100 : Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          messageText,
                                          style: GoogleFonts.prompt(
                                            fontSize: 14,
                                            color: Colors.black87,
                                            height: 1.5,
                                          ),
                                          textAlign: isCurrentUser ? TextAlign.right : TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')}',
                                      style: TextStyle(fontSize: 12, color: Colors.black),
                                      textAlign: isCurrentUser ? TextAlign.right : TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              if (isCurrentUser) SizedBox(width: 8),
                              if (isCurrentUser)
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.teal.shade300,
                                  backgroundImage: profileImageUrl.isNotEmpty
                                      ? NetworkImage(profileImageUrl)
                                      : null,
                                  child: profileImageUrl.isEmpty
                                      ? Icon(Icons.person, color: Colors.white)
                                      : null,
                                ),
                            ],
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              style: GoogleFonts.prompt(),
              decoration: InputDecoration(
                labelText: 'พิมพ์ข้อความ...',
                labelStyle: GoogleFonts.prompt(color: Colors.teal.shade700),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.teal.shade700),
            onPressed: _postMessage,
          ),
        ],
      ),
    );
  }
}
