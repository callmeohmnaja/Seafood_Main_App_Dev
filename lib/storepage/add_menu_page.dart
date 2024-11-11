import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:seafood_app/storepage/store_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'เพิ่มเมนูอาหาร',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: AddMenuPage(),
    );
  }
}

class AddMenuPage extends StatefulWidget {
  const AddMenuPage({super.key});

  @override
  _AddMenuPageState createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = pickedFile;
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _submitForm() async {
    if (_nameController.text.isEmpty || _priceController.text.isEmpty) {
      print('กรุณากรอกข้อมูลให้ครบถ้วน');
      return;
    }

    if (_image == null) {
      print('กรุณาเลือกรูปภาพ');
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref().child('menu_images/$fileName');

      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = storageRef.putData(await _image!.readAsBytes());
      } else {
        uploadTask = storageRef.putFile(File(_image!.path));
      }

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User not logged in.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // ดึงข้อมูลเอกสารผู้ใช้จากคอลเล็กชัน 'users'
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        print('User document not found.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // ดึง uid และชื่อร้านจากเอกสารในคอลเล็กชัน 'users'
      final uidFromFirestore = userDoc.data()?['uid'] ?? '';
      final restaurantName = userDoc.data()?['username'] ?? 'ไม่ทราบชื่อร้านอาหาร'; // ชื่อร้านค้า

      final menuRef = FirebaseFirestore.instance.collection('menu').doc();

      // บันทึกข้อมูลเมนูไปยัง Firestore พร้อมกับ uid ที่ดึงมาจากคอลเล็กชัน 'users'
      await menuRef.set({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'image_url': downloadUrl,
        'customUid': uidFromFirestore, // ใช้ uid ที่ดึงจาก Firestore
        'username': restaurantName, // ใช้ชื่อร้านอาหาร
      });

      print('Menu item added successfully.');

      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() {
        _image = null;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มเมนูอาหาร'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => StoreDashboard()));
          },
        ),
        backgroundColor: Colors.brown.shade50,
      ),
      body: Container(
        width: double.infinity, // Make the container full width
        height: double.infinity, // Make the container full height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade50, Colors.brown.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: _image != null
                    ? Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.brown, width: 1),
                          image: DecorationImage(
                            image: kIsWeb ? NetworkImage(_image!.path) : FileImage(File(_image!.path)) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.brown, width: 1),
                        ),
                        child: Icon(Icons.add_a_photo, size: 50, color: Colors.brown),
                      ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.upload_file),
                  label: Text('อัปโหลดรูปภาพ'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.brown.shade600,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildTextField('ชื่อเมนู', _nameController),
              SizedBox(height: 16),
              _buildTextField('รายละเอียด', _descriptionController, maxLines: 3),
              SizedBox(height: 16),
              _buildTextField('ราคา', _priceController, keyboardType: TextInputType.number),
              SizedBox(height: 16),
              Center(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.brown.shade600,
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('บันทึก'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}
