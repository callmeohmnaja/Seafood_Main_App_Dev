import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:seafood_app/model/profile.dart';
import 'package:seafood_app/screen/food_app.dart';

// ignore: use_key_in_widget_constructors
class LoginScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

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
            appBar: AppBar(title: Text('ลงชื่อเข้าใช้')),
            body: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white, // เปลี่ยนพื้นหลังเป็นสีขาว
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Text('รหัสผ่าน', style: TextStyle(fontSize: 20, color: Colors.black)),
                      _buildTextFormField(
                        obscureText: true,
                        validator: RequiredValidator(errorText: 'กรุณาป้อนรหัสผ่าน'),
                        onSaved: (password) {
                          profile.password = password;
                        },
                      ),
                      SizedBox(height: 20),
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
                                await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: profile.email.toString(),
                                  password: profile.password.toString(),
                                ).then((value) {
                                  formKey.currentState!.reset();
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                    return FoodApp(); //ไปหน้า FoodApp
                                  }));
                                });
                              } on FirebaseAuthException catch (e) {
                                Fluttertoast.showToast(msg: e.message.toString());
                              }
                            }
                          },
                          icon: Icon(Icons.login), // ใช้ไอคอนที่เหมาะสมสำหรับการล็อคอิน
                          label: Text(
                            'ลงชื่อเข้าใช้',
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

  Widget _buildTextFormField({bool obscureText = false, String? Function(String?)? validator, Function(String?)? onSaved, TextInputType? keyboardType}) {
    return TextFormField(
      obscureText: obscureText,
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
}
