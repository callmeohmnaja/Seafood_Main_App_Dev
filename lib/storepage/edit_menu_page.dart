import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seafood_app/storepage/store_dashboard.dart';

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
  String? _imageUrl; // Store the image URL
  XFile? _newImage; // Store the new image file

  @override
  void initState() {
    super.initState();
    _loadMenuData();
  }

  Future<void> _loadMenuData() async {
    final doc = await FirebaseFirestore.instance
        .collection('menu')
        .doc(widget.menuId)
        .get();
    final data = doc.data() as Map<String, dynamic>;

    _nameController.text = data['name'] ?? '';
    _descriptionController.text = data['description'] ?? '';
    _priceController.text = (data['price'] != null) ? data['price'].toString() : '';
    _imageUrl = data['image_url']; // Get the current image URL
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _newImage = pickedFile;
      });
    }
  }

  Future<String?> _uploadImage(String menuId) async {
    if (_newImage == null) return null; // No new image to upload

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance.ref().child('menu_images/$menuId/$fileName');
    
    try {
      UploadTask uploadTask = storageRef.putFile(File(_newImage!.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL(); // Return the new image URL
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _updateMenu() async {
    if (_formKey.currentState!.validate()) {
      String? newImageUrl = await _uploadImage(widget.menuId);

      await FirebaseFirestore.instance
          .collection('menu')
          .doc(widget.menuId)
          .update({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.tryParse(_priceController.text) ?? 0,
        'image_url': newImageUrl ?? _imageUrl, // Update the image URL if new image uploaded
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขเมนูอาหาร'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => StoreDashboard()));
          },
        ),
        backgroundColor: Colors.brown.shade300,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade50, Colors.brown.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          _imageUrl!,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      )
                    : SizedBox(),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.upload_file),
                    label: Text('อัปโหลดรูปใหม่'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.brown.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _buildTextField('ชื่อเมนู', _nameController),
                SizedBox(height: 16),
                _buildTextField('รายละเอียด', _descriptionController, maxLines: 3),
                SizedBox(height: 16),
                _buildTextField('ราคา', _priceController, keyboardType: TextInputType.number),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _updateMenu,
                  child: Text('อัปเดตเมนู'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.brown.shade300,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.brown),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}
