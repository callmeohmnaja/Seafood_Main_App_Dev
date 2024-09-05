import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_menu_page.dart';

class EditOrDeleteMenuPage extends StatefulWidget {
  @override
  _EditOrDeleteMenuPageState createState() => _EditOrDeleteMenuPageState();
}

class _EditOrDeleteMenuPageState extends State<EditOrDeleteMenuPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  List<DocumentSnapshot> _menus = [];

  @override
  void initState() {
    super.initState();
    _fetchMenus();
  }

  Future<void> _fetchMenus() async {
    try {
      final customUID = await _getCustomUID();
      if (customUID == null) {
        print('CustomUID not found.');
        return;
      }

      print('CustomUID: $customUID'); // พิมพ์ CustomUID เพื่อตรวจสอบ

      final querySnapshot = await FirebaseFirestore.instance
          .collection('menu')
          .where('customUid',
              isEqualTo: customUID) // ตรวจสอบ customUid ที่เป็นเลข
          .get();

      if (querySnapshot.docs.isEmpty) {
        print(
            'No menus found for customUID $customUID'); // แจ้งเมื่อไม่มีข้อมูล
      } else {
        print(
            'Found ${querySnapshot.docs.length} menus for customUID $customUID');
      }

      setState(() {
        _menus = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching menus: $e');
    }
  }

  Future<String?> _getCustomUID() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No user is currently signed in.');
        return null;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final uidString = doc.data()?['uid'] as String?;
        print('UID from user document: $uidString'); // พิมพ์ UID เพื่อตรวจสอบ
        if (uidString != null) {
          return uidString; // ส่งคืนเป็น String ถ้า customUid เป็น String
        } else {
          print('UID not found in user document.');
          return null;
        }
      } else {
        print('User document does not exist.');
        return null;
      }
    } catch (e) {
      print('Error fetching UID: $e');
      return null;
    }
  }

  void _navigateToEdit(String menuId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMenuPage(menuId: menuId),
      ),
    );
  }

  void _deleteMenu(String menuId) async {
    await FirebaseFirestore.instance.collection('menu').doc(menuId).delete();
    _fetchMenus(); // Refresh the list after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขหรือลบเมนูอาหาร'),
      ),
      body: _menus.isEmpty
          ? Center(child: Text('ไม่มีเมนูอาหาร'))
          : ListView.builder(
              itemCount: _menus.length,
              itemBuilder: (context, index) {
                final menu = _menus[index];
                final menuId = menu.id;
                final menuData = menu.data() as Map<String, dynamic>;
                return ListTile(
                  leading: menuData['image_url'] != null
                      ? Image.network(menuData['image_url'],
                          width: 50, height: 50, fit: BoxFit.cover)
                      : Icon(Icons.image),
                  title: Text(menuData['name'] ?? 'ไม่มีชื่อ'),
                  subtitle: Text(
                      '${menuData['description'] ?? 'ไม่มีคำอธิบาย'}\nราคา: ${menuData['price'] ?? 'ไม่มีราคา'}'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _navigateToEdit(menuId),
                  ),
                  onLongPress: () => _deleteMenu(menuId),
                );
              },
            ),
    );
  }
}
