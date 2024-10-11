import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:seafood_app/screen/raiderpage/raider_dashboard.dart';

class Editprofileforraider extends StatefulWidget {
  const Editprofileforraider({super.key});

  @override
  State<Editprofileforraider> createState() => _EditprofileforraiderState();
}

class _EditprofileforraiderState extends State<Editprofileforraider> {
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _nameraider;
  String? _vehicleraider;
  String? _phoneraider;
  String? _factoryraider;
  String? _departmentraider;
  
Future<void> _updateUserProfile() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        // อัปเดตข้อมูลใน Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'username': _nameraider,
          'vehicle': _vehicleraider,
          'contactNumber': _phoneraider,
          'faculty': _factoryraider,
          'department': _departmentraider,
         
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
        );
      }
    } catch (e) {
      // ignore: avoid_print
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
        title: Text(""),
        backgroundColor: Colors.teal,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => RaiderDashboard()));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent.shade100],
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
                // ฟิลด์กรอกชื่อ
                Text("ชื่อผู้ใช้", style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 10),
                _buildTextFormField(
                  hintText: 'กรอกชื่อของคุณ',
                  validator: RequiredValidator(errorText: 'กรุณากรอกชื่อ'),
                  onSaved: (value) {
                    _nameraider = value;
                  },
                ),
                SizedBox(height: 20),
                Text("รถ", style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 10),
                _buildTextFormField(
                  hintText: 'กรอกข้อมูลรถของคุณ',
                  keyboardType: TextInputType.emailAddress,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณากรอกข้อมูลรถของคุณ'),
                  ]),
                  onSaved: (value) {
                    _vehicleraider = value;
                  },
                ),
                    SizedBox(height: 20),
                Text("คณะ", style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 10),
                _buildTextFormField(
                  hintText: 'กรอกคณะของคุณ',
                  keyboardType: TextInputType.emailAddress,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณากรอกคณะของคุณ'),
                  ]),
                  onSaved: (value) {
                    _factoryraider = value;
                  },
                ),
                    SizedBox(height: 20),
                Text("สาขา", style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 10),
                _buildTextFormField(
                  hintText: 'กรอกสาขาของคุณ',
                  keyboardType: TextInputType.emailAddress,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณากรอกสาขาของคุณ'),
                  ]),
                  onSaved: (value) {
                    _departmentraider = value;
                  },
                ),
          

                SizedBox(height: 20),
                Text("หมายเลขโทรศัพท์", style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 10),
                _buildTextFormField(
                  hintText: 'กรอกหมายเลขโทรศัพท์ของคุณ',
                  keyboardType: TextInputType.phone,
                  validator: RequiredValidator(errorText: 'กรุณากรอกหมายเลขโทรศัพท์'),
                  onSaved: (value) {
                    _phoneraider = value;
                  },
                ),
                SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        _updateUserProfile(); // เรียกฟังก์ชันอัปเดตโปรไฟล์
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

  // ฟังก์ชันสร้าง TextFormField
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
        fillColor: Colors.white.withOpacity(0.8),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
