import 'package:flutter/material.dart';
import 'package:seafood_app/screen/food_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditprofilePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => FoodApp()));
          },
        ),
        title: Text('ตั้งค่าบัญชี'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'แก้ไขข้อมูลส่วนตัว',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: 'ชื่อผู้ใช้',
                  icon: Icons.person,
                  controller: _usernameController,
                ),
                SizedBox(height: 10),
                _buildTextField(
                  label: 'แก้ไขอีเมล',
                  icon: Icons.email,
                  controller: _emailController,
                ),
                SizedBox(height: 10),
                _buildTextField(
                  label: 'ที่อยู่',
                  icon: Icons.home,
                  controller: _addressController,
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        _saveUserData(
                          _usernameController.text,
                          _emailController.text,
                          _addressController.text,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('กำลังบันทึกข้อมูล')),
                        );
                      }
                    },
                    child: Text('บันทึก'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกข้อมูล';
        }
        return null;
      },
    );
  }

  void _saveUserData(String username, String email, String address) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).update({
        'username': username,
        'email': email,
        'address': address,
      }).then((_) {
        print('ข้อมูลถูกบันทึกสำเร็จ');
      }).catchError((error) {
        print('เกิดข้อผิดพลาด: $error');
      });
    }
  }
}
