import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class EditprofilePage extends StatefulWidget {
  const EditprofilePage({super.key});

  @override
  _EditprofilePageState createState() => _EditprofilePageState();
}

class _EditprofilePageState extends State<EditprofilePage> {
  final formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _phone;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไขโปรไฟล์"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent], 
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
                    _name = value;
                  },
                ),
                SizedBox(height: 20),



                Text("อีเมล", style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 10),
                _buildTextFormField(
                  hintText: 'กรอกอีเมลของคุณ',
                  keyboardType: TextInputType.emailAddress,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'กรุณากรอกอีเมล'),
                    EmailValidator(errorText: 'รูปแบบอีเมลไม่ถูกต้อง'),
                  ]),
                  onSaved: (value) {
                    _email = value;
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
                    _phone = value;
                  },
                ),
                SizedBox(height: 40),

                Text("รหัสผ่าน", style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 10),
                _buildTextFormField(
                  hintText: 'กรอกรหัสของคุณ',
                  keyboardType: TextInputType.phone,
                  validator: RequiredValidator(errorText: 'กรุณากกรอกรหัสของคุณ'),
                  onSaved: (value) {
                    _password = value;
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
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
                      
                        );
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
