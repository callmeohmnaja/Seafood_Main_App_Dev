import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:seafood_app/storepage/store_dashboard.dart';

class EditstorePage extends StatefulWidget {
  const EditstorePage({super.key});

  @override
  State<EditstorePage> createState() => _EditstorePageState();
}

class _EditstorePageState extends State<EditstorePage> {
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  String? _namestore;
  String? _emailstore;
  String? _phonestore;
  String? _menutype;

  Future<void> _updateUserProfile() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        await _fireStore.collection("users").doc(user.uid).update({
          'username': _namestore,
          'email': _emailstore,
          'phone': _phonestore,
          'menu': _menutype,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลร้านค้า'),
        backgroundColor: Colors.brown.shade50,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StoreDashboard()),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade50, Colors.brown.shade100, Colors.brown.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormFieldLabel("ชื่อผู้ใช้"),
                _buildTextFormField(
                  hintText: 'กรอกชื่อของคุณ',
                  validator: RequiredValidator(errorText: 'กรุณากรอกชื่อ'),
                  onSaved: (value) {
                    _namestore = value;
                  },
                ),
                _buildFormFieldLabel("อีเมล"),
                _buildTextFormField(
                  hintText: 'กรอกอีเมลของคุณ',
                  keyboardType: TextInputType.emailAddress,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณากรอกอีเมล'),
                    EmailValidator(errorText: 'รูปแบบอีเมลไม่ถูกต้อง'),
                  ]),
                  onSaved: (value) {
                    _emailstore = value;
                  },
                ),
                _buildFormFieldLabel("หมายเลขโทรศัพท์"),
                _buildTextFormField(
                  hintText: 'กรอกหมายเลขโทรศัพท์ของคุณ',
                  keyboardType: TextInputType.phone,
                  validator: RequiredValidator(errorText: 'กรุณากรอกหมายเลขโทรศัพท์'),
                  onSaved: (value) {
                    _phonestore = value;
                  },
                ),
                _buildFormFieldLabel("ประเภท"),
                _buildTextFormField(
                  hintText: 'กรอกประเภทที่ท่านจะจําหน่าย',
                  validator: RequiredValidator(errorText: 'กรุณากรอกประเภทที่ท่านจะจําหน่าย'),
                  onSaved: (value) {
                    _menutype = value;
                  },
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.green.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        _updateUserProfile();
                      }
                    },
                    child: Text('บันทึกข้อมูล', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        label,
        style: TextStyle(color: Colors.brown.shade900, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextFormField({
    required String hintText,
    String? Function(String?)? validator,
    Function(String?)? onSaved,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
