import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:seafood_app/model/profile.dart';
import 'package:seafood_app/screen/food_app.dart';
import 'package:seafood_app/screen/raiderpage/raider_dashboard.dart';
import 'package:seafood_app/storepage/store_dashboard.dart'; // นำเข้า StoreDashboard ที่นี่

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
            appBar: AppBar(
              title: Text(''),
              backgroundColor: Colors.teal,
              elevation: 0,
            ),
            body: Container(
              width: double.infinity, // Full-width
              height: double.infinity, // Full-height
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Text(
                          'ยินดีต้อนรับ!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'กรุณาลงชื่อเข้าใช้เพื่อเข้าถึงแอปพลิเคชัน Ku Food Delivery',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 40),
                        Text('อีเมล',
                            style: TextStyle(fontSize: 20, color: Colors.white)),
                        SizedBox(height: 8),
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
                        SizedBox(height: 20),
                        Text('รหัสผ่าน',
                            style: TextStyle(fontSize: 20, color: Colors.white)),
                        SizedBox(height: 8),
                        _buildPasswordFormField(),
                        SizedBox(height: 30),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  _loginUser();
                                }
                              },
                              icon: Icon(Icons.login_sharp, color: Colors.white),
                              label: Text('ลงชื่อเข้าใช้',
                                  style: TextStyle(fontSize: 20, color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  Future<void> _loginUser() async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: profile.email.toString(),
        password: profile.password.toString(),
      );

      // Query ข้อมูลจาก Firestore ตามอีเมลของผู้ใช้
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: profile.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;
        String role = userDoc['role'];

        // นำทางไปยังหน้าที่เหมาะสมตามบทบาท
        Widget nextPage;
        if (role == 'ร้านอาหาร') {
          nextPage = StoreDashboard();
        } else if (role == 'ไรเดอร์') {
          nextPage = RaiderDashboard();
        } else {
          nextPage = FoodApp();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      } else {
        Fluttertoast.showToast(msg: 'ไม่พบข้อมูลผู้ใช้ในระบบ');
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: 'เกิดข้อผิดพลาด: ${e.toString()}');
    }
  }

  Widget _buildTextFormField({
    bool obscureText = false,
    String? Function(String?)? validator,
    Function(String?)? onSaved,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      obscureText: obscureText,
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        hintText: 'กรอกข้อมูลของคุณ',
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
        fillColor: Colors.white.withOpacity(0.9),
        hintText: 'กรอกรหัสผ่านของคุณ',
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }
}
