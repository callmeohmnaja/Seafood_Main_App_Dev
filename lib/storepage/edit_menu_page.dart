import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditMenuPage extends StatefulWidget {
  final String menuId;

  EditMenuPage({required this.menuId});

  @override
  _EditMenuPageState createState() => _EditMenuPageState();
}

class _EditMenuPageState extends State<EditMenuPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMenuData();
  }

  Future<void> _loadMenuData() async {
    final doc = await FirebaseFirestore.instance
        .collection('menu') // Corrected collection name
        .doc(widget.menuId)
        .get();
    final data = doc.data() as Map<String, dynamic>;
    _nameController.text = data['name'] ?? '';
    _descriptionController.text = data['description'] ?? '';
    _priceController.text = data['price'] ?? '';
  }

  Future<void> _updateMenu() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('menu') // Corrected collection name
          .doc(widget.menuId)
          .update({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': _priceController.text,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขเมนูอาหาร'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'ชื่อเมนู'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อเมนู';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'คำอธิบาย'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกคำอธิบาย';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'ราคา'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกราคา';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _updateMenu,
                child: Text('อัปเดตเมนู'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
