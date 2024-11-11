import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seafood_app/storepage/store_dashboard.dart';
import 'edit_menu_page.dart';

class EditOrDeleteMenuPage extends StatefulWidget {
  const EditOrDeleteMenuPage({super.key});

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

      final querySnapshot = await FirebaseFirestore.instance
          .collection('menu')
          .where('customUid', isEqualTo: customUID) // กรองข้อมูลตาม customUid
          .get();

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

      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final uidString = doc.data()?['uid'] as String?;
        return uidString;
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => StoreDashboard()));
          },
        ),
        backgroundColor: Colors.brown.shade50,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade50, Colors.brown.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _menus.isEmpty
              ? Center(
                  child: Text(
                    'ไม่มีเมนูอาหาร',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                )
              : ListView.builder(
                  itemCount: _menus.length,
                  itemBuilder: (context, index) {
                    final menu = _menus[index];
                    final menuId = menu.id;
                    final menuData = menu.data() as Map<String, dynamic>;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        leading: menuData['image_url'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  menuData['image_url'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.image, size: 60, color: Colors.grey),
                        title: Text(
                          menuData['name'] ?? 'ไม่มีชื่อ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.brown),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menuData['description'] ?? 'ไม่มีคำอธิบาย',
                              style: TextStyle(color: Colors.brown.shade600),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'ราคา: ${menuData['price'] ?? 'ไม่มีราคา'}',
                              style: TextStyle(color: Colors.brown),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _navigateToEdit(menuId),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteMenu(menuId),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
