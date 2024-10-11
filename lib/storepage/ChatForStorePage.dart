import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seafood_app/storepage/store_dashboard.dart';

class Chatforstorepage extends StatefulWidget {
  @override
  _Chatforstorepage createState() => _Chatforstorepage();
}

class _Chatforstorepage extends State<Chatforstorepage> {
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
    return _firestore.collection('chat_messages').orderBy('createdAt', descending: true).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KU Chat!', style: GoogleFonts.prompt()),
        backgroundColor: Colors.brown.shade100,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
          Navigator.push(context,MaterialPageRoute(builder: (context)=> StoreDashboard()));
        }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade100, Colors.brown.shade200, Colors.brown.shade300],
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
                    return Center(child: Text('ยังไม่พบข้อความ', style: GoogleFonts.prompt()));
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
                          backgroundColor: Colors.brown.shade200,
                          backgroundImage: profileImageUrl.isNotEmpty ? NetworkImage(profileImageUrl) : null,
                          child: profileImageUrl.isEmpty ? Icon(Icons.person, color: Colors.brown.shade700) : null,
                        ),
                        title: Text(
                          messageSender,
                          style: GoogleFonts.prompt(fontWeight: FontWeight.bold, color: Colors.brown.shade800),
                        ),
                        subtitle: Text(
                          messageText,
                          style: TextStyle(color: Colors.brown.shade700),
                        ),
                        trailing: Text(
                          '${messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 12, color: Colors.brown.shade500),
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
      color: Colors.brown.shade100,
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
            icon: Icon(Icons.send, color: Colors.brown.shade700),
            onPressed: _postMessage,
          ),
        ],
      ),
    );
  }
}
