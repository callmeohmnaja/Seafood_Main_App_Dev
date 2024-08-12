import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า Firestore
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:seafood_app/model/profile.dart';
import 'package:seafood_app/screen/home.dart';

// ignore: use_key_in_widget_constructors
class RegisterScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  // สำหรับการแสดง/ซ่อนรหัสผ่าน
  bool _isObscure = true;
  bool _isObscureConfirm = true;

  // ตัวแปรสำหรับเลือกบทบาท
  String _currentRole = 'ลูกค้า'; // ค่าเริ่มต้น
  final List<String> _roles = ['ลูกค้า', 'ไรเดอร์', 'ร้านอาหาร'];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(child: Text('${snapshot.error}')),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: Text('สร้างบัญชีผู้ใช้')),
            body: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white, // เปลี่ยนพื้นหลังเป็นสีขาว
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ช่องกรอกชื่อผู้ใช้
                      Text('ชื่อผู้ใช้', style: TextStyle(fontSize: 20, color: Colors.black)),
                      _buildTextFormField(
                        validator: RequiredValidator(errorText: 'กรุณาป้อนชื่อผู้ใช้'),
                        onSaved: (username) {
                          profile.username = username; // สร้างตัวแปร username ใน Profile
                        },
                      ),
                      SizedBox(height: 15),

                      // ช่องกรอกอีเมล
                      Text('อีเมล', style: TextStyle(fontSize: 20, color: Colors.black)),
                      _buildTextFormField(
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'กรุณาป้อนอีเมล'),
                          EmailValidator(errorText: 'รูปแบบอีเมลไม่ถูกต้อง'),
                        ]),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (email) {
                          profile.email = email;
                        },
                      ),
                      SizedBox(height: 15),

                      // ช่องกรอกรหัสผ่าน
                      Text('รหัสผ่าน', style: TextStyle(fontSize: 20, color: Colors.black)),
                      _buildPasswordFormField(
                        obscureText: _isObscure,
                        onSaved: (password) {
                          profile.password = password;
                        },
                        toggleVisibility: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      SizedBox(height: 15),

                      // ช่องกรอกรหัสผ่านยืนยัน
                      Text('ยืนยันรหัสผ่าน', style: TextStyle(fontSize: 20, color: Colors.black)),
                      _buildPasswordFormField(
                        obscureText: _isObscureConfirm,
                        toggleVisibility: () {
                          setState(() {
                            _isObscureConfirm = !_isObscureConfirm;
                          });
                        },
                      ),
                      SizedBox(height: 15),

                      // Dropdown สำหรับเลือกบทบาท
                      Text('บทบาท', style: TextStyle(fontSize: 20, color: Colors.black)),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200], // ใช้สีเทาอ่อนสำหรับช่องกรอกข้อมูล
                          border: OutlineInputBorder(),
                        ),
                        value: _currentRole,
                        items: _roles.map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _currentRole = newValue!;
                          });
                        },
                      ),
                      SizedBox(height: 15),

                      // ปุ่มลงทะเบียน
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.green, // ปรับสีพื้นหลังปุ่ม
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // กำหนดมุมให้โค้ง
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              try {
                                // สร้างผู้ใช้ใหม่ใน Firebase Auth
                                UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                  email: profile.email.toString(),
                                  password: profile.password.toString(),
                                );

                                // เก็บข้อมูลใน Firestore
                                await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
                                  'username': profile.username, // เก็บชื่อผู้ใช้
                                  'email': profile.email,
                                  'role': _currentRole,
                                });

                                formKey.currentState!.reset();
                                Fluttertoast.showToast(msg: 'สร้างบัญชีเรียบร้อย');
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                  return HomeScreen();
                                }));
                              } on FirebaseAuthException catch (e) {
                                String message;
                                if (e.code == 'email-already-in-use') {
                                  message = 'อีเมลซ้ำไม่สามารถใช้งานได้';
                                } else if (e.code == 'weak-password') {
                                  message = 'รหัสผ่านต้องมีความยาว 6 ตัวอักษรขึ้นไป';
                                } else {
                                  message = e.message.toString();
                                }

                                Fluttertoast.showToast(msg: message);
                              }
                            }
                          },
                          icon: Icon(Icons.app_registration_rounded),
                          label: Text(
                            'ลงทะเบียน',
                            style: TextStyle(fontSize: 20),
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
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildTextFormField({String? Function(String?)? validator, Function(String?)? onSaved, TextInputType? keyboardType}) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200], // ใช้สีเทาอ่อนสำหรับช่องกรอกข้อมูล
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordFormField({bool obscureText = true, Function(String?)? onSaved, required VoidCallback toggleVisibility}) {
    return Stack(
      children: [
        TextFormField(
          obscureText: obscureText,
          validator: RequiredValidator(errorText: 'กรุณาป้อนรหัสผ่าน'),
          onSaved: onSaved,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200], // ใช้สีเทาอ่อนสำหรับช่องกรอกข้อมูล
            border: OutlineInputBorder(),
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: toggleVisibility,
          ),
        ),
      ],
    );
  }
}
