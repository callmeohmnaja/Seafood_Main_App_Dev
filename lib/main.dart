import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seafood_app/screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA_6BqYTJ_NzPODbKhhDvHuI0-97kyemPw",
      appId: "1:785736376641:android:591dc33dc281627234c1c0",
      messagingSenderId: "785736376641",
      projectId: "database-seafood-app",
      storageBucket: "database-seafood-app.appspot.com",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seafood App',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: HomeScreen(),
    );
  }
}
