import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class EditprofilePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  'ตั้งค่าบัญชี',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: 'ชื่อผู้ใช้',
                  icon: Icons.person,
                ),
                SizedBox(height: 10),
                _buildTextField(
                  label: 'แก้ไขอีเมล',
                  icon: Icons.email,
                ),
                SizedBox(height: 10),
                _buildTextField(
                  label: 'ที่อยู่',
                  icon: Icons.home,
                ),
                SizedBox(height: 10),
                _buildPasswordTextField(
                  label: 'รหัสผ่าน',
                  icon: Icons.lock,
                ),
                SizedBox(height: 10),
                _buildPasswordTextField(
                  label: 'ยืนยันรหัสผ่าน',
                  icon: Icons.lock,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('กำลังบันทึกข้อมูล')),
                      );
                    }
                  },
                  // ignore: sort_child_properties_last
                  child: Text('บันทึก'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
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
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(),
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

  Widget _buildPasswordTextField({
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกรหัสผ่าน';
        }
        return null;
      },
    );
  }
}