import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_menu_page.dart';

class EditOrDeleteMenuPage extends StatefulWidget {
  @override
  _EditOrDeleteMenuPageState createState() => _EditOrDeleteMenuPageState();
}

class _EditOrDeleteMenuPageState extends State<EditOrDeleteMenuPage> {
  final Stream<QuerySnapshot> _menusStream =
      FirebaseFirestore.instance.collection('menus').snapshots();

  void _navigateToEdit(String menuId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMenuPage(menuId: menuId),
      ),
    );
  }

  void _deleteMenu(String menuId) async {
    await FirebaseFirestore.instance.collection('menus').doc(menuId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขหรือลบเมนูอาหาร'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _menusStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('ไม่มีเมนูอาหาร'));
          }
          final menus = snapshot.data!.docs;
          return ListView.builder(
            itemCount: menus.length,
            itemBuilder: (context, index) {
              final menu = menus[index];
              final menuId = menu.id;
              final menuData = menu.data() as Map<String, dynamic>;
              return ListTile(
                leading: menuData['image_url'] != null
                    ? Image.network(menuData['image_url'],
                        width: 50, height: 50, fit: BoxFit.cover)
                    : Icon(Icons.image),
                title: Text(menuData['name'] ?? 'ไม่มีชื่อ'),
                subtitle: Text(menuData['description'] ?? 'ไม่มีคำอธิบาย'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _navigateToEdit(menuId),
                ),
                onLongPress: () => _deleteMenu(menuId),
              );
            },
          );
        },
      ),
    );
  }
}
