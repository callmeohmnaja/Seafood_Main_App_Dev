import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart'
    // ignore: library_prefixes
    as formValidators;
import 'package:seafood_app/model/profile.dart';
import 'package:seafood_app/screen/food_app.dart';
import 'package:seafood_app/screen/raiderpage/raider_dashboard.dart';
import 'package:seafood_app/storepage/store_dashboard.dart';

// ignore: use_key_in_widget_constructors
class RegisterScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  bool _isObscure = true;
  bool _isObscureConfirm = true;

  String _currentRole = 'ลูกค้า';
  final List<String> _roles = ['ลูกค้า', 'ไรเดอร์', 'ร้านอาหาร'];

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController menuController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController facultyController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();

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
            appBar: AppBar(
              title: Text(''),
              backgroundColor: Colors.teal,
              elevation: 0,
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              // ignore: prefer_const_constructors
              decoration: BoxDecoration(
                // ignore: prefer_const_constructors
                gradient: LinearGradient(
                  // ignore: prefer_const_literals_to_create_immutables
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
                        SizedBox(height: 20),
                        Text(
                          'ลงทะเบียน',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'กรุณากรอกข้อมูลให้ครบถ้วนเพื่อสร้างบัญชีผู้ใช้ใหม่',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 30),
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
                              // ignore: curly_braces_in_flow_control_structures
                              return 'กรุณาป้อนรหัสผ่านยืนยัน';
                            if (value != passwordController.text)
                              // ignore: curly_braces_in_flow_control_structures
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
                        if (_currentRole == 'ร้านอาหาร' || _currentRole == 'ลูกค้า') ...[
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
                        if (_currentRole == 'ไรเดอร์') ...[
                          _buildTextFormField(
                            controller: vehicleController,
                            hintText: 'ข้อมูลรถ/รถยนต์หรือมอไซค์',
                            label: 'ข้อมูลรถ',
                            validator: formValidators.RequiredValidator(
                                errorText: 'กรุณาป้อนข้อมูลรถ'),
                            onSaved: (value) => profile.vehicle = value!,
                          ),
                          _buildTextFormField(
                            controller: contactNumberController,
                            hintText: 'เบอร์ติดต่อ',
                            label: 'เบอร์ติดต่อ',
                            validator: formValidators.RequiredValidator(
                                errorText: 'กรุณาป้อนเบอร์ติดต่อ'),
                            onSaved: (value) => profile.contactNumber = value!,
                          ),
                          _buildTextFormField(
                            controller: fullNameController,
                            hintText: 'ชื่อจริง-นามสกุล',
                            label: 'ชื่อจริง-นามสกุล',
                            validator: formValidators.RequiredValidator(
                                errorText: 'กรุณาป้อนชื่อจริง-นามสกุล'),
                            onSaved: (value) => profile.fullname = value!,
                          ),
                        ],
                        if (_currentRole == 'ร้านอาหาร') ...[
                          _buildTextFormField(
                            controller: menuController,
                            hintText: 'เมนู (ใช้คอมม่าแยกแต่ละรายการ)',
                            label: 'เมนู',
                            validator: formValidators.RequiredValidator(
                                errorText: 'กรุณาป้อนเมนู'),
                            onSaved: (value) => profile.menu = value!,
                          ),
                        ],
                        SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  _registerUser();
                                }
                              },
                              icon: Icon(Icons.create, color: Colors.white),
                              label: Text(
                                'ลงทะเบียน',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
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
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _registerUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: profile.email.toString(),
        password: profile.password.toString(),
      );

      String customUid = _generateRandomString(10);

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': profile.username,
        'email': profile.email,
        'address': profile.address,
        'phone': profile.phone,
        'vehicle': profile.vehicle,
        'menu': profile.menu,
        'contactNumber': profile.contactNumber,
        'fullName': profile.fullname,
        'uid': customUid,
        'role': _currentRole,
        'balance': 0, 
      });

      Fluttertoast.showToast(
        msg: "ลงทะเบียนสำเร็จ",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Widget nextPage = _currentRole == 'ร้านอาหาร'
          ? StoreDashboard()
          : _currentRole == 'ไรเดอร์'
              ? RaiderDashboard()
              : FoodApp();

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => nextPage));
    } catch (e) {
      Fluttertoast.showToast(
        msg: "ลงทะเบียนไม่สำเร็จ: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          hintText: hintText,
          labelText: label,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          hintText: '********',
          labelText: label,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
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
          fillColor: Colors.white.withOpacity(0.9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        validator: (value) => value == null ? 'กรุณาเลือกบทบาท' : null,
      ),
    );
  }

  String _generateRandomString(int length) {
    const chars = '0123456789';
    Random rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }
}
