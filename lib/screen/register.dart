import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart'
    as formValidators;
import 'package:seafood_app/model/profile.dart';
import 'package:seafood_app/screen/food_app.dart';
import 'package:seafood_app/screen/raiderpage/raider_dashboard.dart';
import 'package:seafood_app/storepage/store_dashboard.dart'; // Import the StoreDashboard screen

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final Profile profile =
      Profile(); // Ensure Profile class has all the required fields
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  bool _isObscure = true;
  bool _isObscureConfirm = true;

  String _currentRole = 'ลูกค้า'; // Default role
  final List<String> _roles = ['ลูกค้า', 'ไรเดอร์', 'ร้านอาหาร'];

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController menuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: Text('Error')),
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          }
          return Scaffold(
            appBar: AppBar(title: Text('สร้างบัญชีผู้ใช้')),
            body: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextFormField(
                        controller: usernameController,
                        hintText: 'ชื่อผู้ใช้',
                        label: 'ชื่อผู้ใช้',
                        validator: formValidators.RequiredValidator(
                            errorText: 'กรุณาป้อนชื่อผู้ใช้'),
                        onSaved: (value) => profile.username = value!,
                      ),
                      _buildTextFormField(
                        controller: emailController,
                        hintText: 'อีเมล',
                        label: 'อีเมล',
                        keyboardType: TextInputType.emailAddress,
                        validator: formValidators.MultiValidator([
                          formValidators.RequiredValidator(
                              errorText: 'กรุณาป้อนอีเมล'),
                          formValidators.EmailValidator(
                              errorText: 'รูปแบบอีเมลไม่ถูกต้อง'),
                        ]),
                        onSaved: (value) => profile.email = value!,
                      ),
                      _buildPasswordFormField(
                        controller: passwordController,
                        obscureText: _isObscure,
                        toggleVisibility: () =>
                            setState(() => _isObscure = !_isObscure),
                        label: 'รหัสผ่าน',
                        validator: formValidators.RequiredValidator(
                            errorText: 'กรุณาป้อนรหัสผ่าน'),
                        onSaved: (value) => profile.password = value!,
                      ),
                      _buildPasswordFormField(
                        controller: confirmPasswordController,
                        obscureText: _isObscureConfirm,
                        toggleVisibility: () => setState(
                            () => _isObscureConfirm = !_isObscureConfirm),
                        label: 'ยืนยันรหัสผ่าน',
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'กรุณาป้อนรหัสผ่านยืนยัน';
                          if (value != passwordController.text)
                            return 'รหัสผ่านไม่ตรงกัน';
                          return null;
                        },
                        onSaved: (value) => profile.passwordConfirm = value!,
                      ),
                      _buildDropdownField(
                        currentRole: _currentRole,
                        roles: _roles,
                        onChanged: (newValue) =>
                            setState(() => _currentRole = newValue!),
                      ),
                      if (_currentRole == 'ร้านอาหาร' ||
                          _currentRole == 'ลูกค้า') ...[
                        _buildTextFormField(
                          controller: addressController,
                          hintText: 'ที่อยู่',
                          label: 'ที่อยู่',
                          validator: formValidators.RequiredValidator(
                              errorText: 'กรุณาป้อนที่อยู่'),
                          onSaved: (value) => profile.address = value!,
                        ),
                        _buildTextFormField(
                          controller: phoneController,
                          hintText: 'เบอร์โทรศัพท์',
                          label: 'เบอร์โทรศัพท์',
                          validator: formValidators.RequiredValidator(
                              errorText: 'กรุณาป้อนเบอร์โทรศัพท์'),
                          onSaved: (value) => profile.phone = value!,
                        ),
                      ],
                      if (_currentRole == 'ไรเดอร์')
                        _buildTextFormField(
                          controller: vehicleController,
                          hintText: 'ข้อมูลรถ',
                          label: 'ข้อมูลรถ',
                          validator: formValidators.RequiredValidator(
                              errorText: 'กรุณาป้อนข้อมูลรถ'),
                          onSaved: (value) => profile.vehicle = value!,
                        ),
                      if (_currentRole == 'ร้านอาหาร')
                        _buildTextFormField(
                          controller: menuController,
                          hintText: 'เมนู (ใช้คอมม่าแยกแต่ละรายการ)',
                          label: 'เมนู',
                          validator: formValidators.RequiredValidator(
                              errorText: 'กรุณาป้อนเมนู'),
                          onSaved: (value) => profile.menu = value!,
                        ),
                      SizedBox(height: 15),
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
                                        .createUserWithEmailAndPassword(
                                  email: profile.email.toString(),
                                  password: profile.password.toString(),
                                );

                                // Generate UID
                                String customUid = _generateRandomString(10);

                                // Save to Firestore
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userCredential.user!.uid)
                                    .set({
                                  'username': profile.username,
                                  'email': profile.email,
                                  'address': profile.address,
                                  'phone': profile.phone,
                                  'vehicle': profile.vehicle,
                                  'menu': profile.menu,
                                  'uid': customUid,
                                  'role': _currentRole,
                                });

                                Fluttertoast.showToast(
                                  msg: "ลงทะเบียนสำเร็จ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );

                                // Navigate based on role
                                Widget nextPage;
                                if (_currentRole == 'ร้านอาหาร') {
                                  nextPage = StoreDashboard();
                                } else if (_currentRole == 'ไรเดอร์') {
                                  nextPage = RaiderDashboard();
                                } else {
                                  nextPage = FoodApp();
                                }

                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => nextPage),
                                );
                              } catch (e) {
                                Fluttertoast.showToast(
                                  msg: "ลงทะเบียนไม่สำเร็จ: $e",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              }
                            }
                          },
                          icon: Icon(Icons.create),
                          label: Text('ลงทะเบียน'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    Function(String?)? onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          hintText: hintText,
          labelText: label,
        ),
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildPasswordFormField({
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    required String label,
    required String? Function(String?) validator,
    Function(String?)? onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          hintText: '********',
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: toggleVisibility,
          ),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDropdownField({
    required String currentRole,
    required List<String> roles,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: DropdownButtonFormField<String>(
        value: currentRole,
        items: roles.map((String role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(role),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          hintText: 'เลือกบทบาท',
        ),
        validator: (value) => value == null ? 'กรุณาเลือกบทบาท' : null,
      ),
    );
  }

  String _generateRandomString(int length) {
    const _chars = '0123456789';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
