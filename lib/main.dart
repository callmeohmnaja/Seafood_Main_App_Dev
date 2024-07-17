import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seafood_app/screen/home.dart';



  void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyA_6BqYTJ_NzPODbKhhDvHuI0-97kyemPw",
      appId: "1:785736376641:android:591dc33dc281627234c1c0",
      messagingSenderId: "785736376641",
      projectId: "database-seafood-app",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: HomeScreen(),
    );
  }
}
