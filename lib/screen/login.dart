import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:seafood_app/model/profile.dart';
import 'package:seafood_app/screen/food_app.dart';
import 'package:seafood_app/storepage/store_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  bool _obscurePassword = true; // สถานะการซ่อนรหัสผ่าน

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
              color: Colors.white,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('อีเมล',
                          style: TextStyle(fontSize: 20, color: Colors.black)),
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
                      Text('รหัสผ่าน',
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                      _buildPasswordFormField(),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                  email: profile.email.toString(),
                                  password: profile.password.toString(),
                                );
                                // ดึงข้อมูลบทบาทจาก Firestore
                                DocumentSnapshot userDoc =
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userCredential.user!.uid)
                                        .get();
                                String role = userDoc['role'];

                                // นำทางไปยังหน้าตามบทบาท
                                if (role == 'ลูกค้า') {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FoodApp()));
                                } else if (role == 'ไรเดอร์') {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FoodApp()));
                                } else if (role == 'ร้านอาหาร') {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StoreDashboard())); //กลับไปหน้าเปิดร้านอาหาร
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'บทบาทไม่ถูกต้อง');
                                }
                              } on FirebaseAuthException catch (e) {
                                Fluttertoast.showToast(
                                    msg: e.message.toString());
                              } catch (e) {
                                Fluttertoast.showToast(
                                    msg: 'เกิดข้อผิดพลาด: ${e.toString()}');
                              }
                            }
                          },
                          icon: Icon(Icons.login_sharp),
                          label: Text('ลงชื่อเข้าใช้',
                              style: TextStyle(fontSize: 20)),
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

  Widget _buildTextFormField(
      {bool obscureText = false,
      String? Function(String?)? validator,
      Function(String?)? onSaved,
      TextInputType? keyboardType}) {
    return TextFormField(
      obscureText: obscureText,
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordFormField() {
    return TextFormField(
      obscureText: _obscurePassword,
      validator: RequiredValidator(errorText: 'กรุณาป้อนรหัสผ่าน'),
      onSaved: (password) {
        profile.password = password;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword; // สลับสถานะการซ่อนรหัสผ่าน
            });
          },
        ),
      ),
    );
  }
}
