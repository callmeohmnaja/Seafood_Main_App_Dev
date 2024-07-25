import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:seafood_app/model/profile.dart';
import 'package:seafood_app/screen/food_app.dart';
// import 'package:seafood_app/screen/welcome.dart';

// ignore: use_key_in_widget_constructors
class LoginScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  // ignore: unnecessary_new
  Profile profile = new Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            // ignore: curly_braces_in_flow_control_structures
            return Scaffold(
              appBar: AppBar(title: Text('Error')),
              body: Center(child: Text('${snapshot.error}')),
            );
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
                appBar: AppBar(title: Text('ลงชื่อเข้าใช้')),
                body: Container(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('อีเมล', style: TextStyle(fontSize: 20)),
                            TextFormField(
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'กรุณาป้อนอีเมล'),
                                EmailValidator(
                                    errorText: 'รูปแบบอีเมลไม่ถูกต้อง')
                              ]),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (email) {
                                profile.email = email;
                              },
                            ),
                            SizedBox(height: 15),
                            Text('รหัสผ่าน', style: TextStyle(fontSize: 20)),
                            TextFormField(
                                obscureText: true,
                                validator: RequiredValidator(
                                    errorText: 'กรุณาป้อนรหัสผ่าน'),
                                onSaved: (password) {
                                  profile.password = password;
                                }),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        try {
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email:
                                                      profile.email.toString(),
                                                  password: profile.password
                                                      .toString())
                                              .then((value) {
                                            formKey.currentState!.reset();
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return FoodApp(); //ไปหน้า foodApp
                                            }));
                                          });
                                        } on FirebaseAuthException catch (e) {
                                          Fluttertoast.showToast(
                                              msg: e.message.toString());
                                        }
                                      }
                                    },
                                    icon: Icon(Icons.app_registration_rounded),
                                    label: Text(
                                      'ลงชื่อเข้าใช้',
                                      style: TextStyle(fontSize: 20),
                                    )))
                          ],
                        ),
                      )),
                ));
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}