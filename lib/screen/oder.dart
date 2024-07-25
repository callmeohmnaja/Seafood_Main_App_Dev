// import 'package:flutter/material.dart';
// import 'package:seafood_app/screen/favorites_page.dart';
// import 'package:seafood_app/screen/food_app.dart';
// import 'package:seafood_app/screen/home.dart';
// import 'package:seafood_app/screen/profile.dart';
// import 'package:seafood_app/screen/raider_page.dart';
// import 'package:seafood_app/screen/store_page.dart';
// import 'package:seafood_app/screen/support_page.dart';



// // ignore: use_key_in_widget_constructors
// class RecipesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recipes'),
//       ),
//        drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.green,
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text('หน้าแรก'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => FoodApp()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.restaurant_menu),
//               title: Text('ออเดอร์ของฉัน'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RecipesPage()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.favorite),
//               title: Text('สิ่งที่ถูกใจ'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => FavoritesPage()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('โปรไฟล์'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ProfilePage()),
//                 );
//               },
//             ),
//                ListTile(
//               leading: Icon(Icons.motorcycle),
//               title: Text('สมัครไรเดอร์'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RaiderPage()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.store),
//               title: Text('เปิดร้านอาหาร'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => StorePage()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.support),
//               title: Text('แจ้งปัญหา'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SupportPage()),
//                 );
//               },
//             ),
//              ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('ออกจากระบบ'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen()), //แก้ให้กลับไปหน้าหลัก
//                 );
//               },
//             ),
//           ],
//         ),
//        ),
    
//       body: Center(
//         child: Text('Recipes Page Content'),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:seafood_app/screen/favorites_page.dart';
import 'package:seafood_app/screen/mainhome_page.dart';
import 'package:seafood_app/screen/profile.dart';
import 'package:seafood_app/screen/raider_page.dart';
import 'package:seafood_app/screen/store_page.dart';
import 'package:seafood_app/screen/support_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RecipesPage(),
      routes: {
        '/home': (context) => HomePage(), // Replace with your actual home page
        '/favorites': (context) => FavoritesPage(),
        '/profile': (context) => ProfilePage(),
        '/raider': (context) => RaiderPage(),
        '/store': (context) => StorePage(),
        '/support': (context) => SupportPage(),
      },
    );
  }
}

class RecipesPage extends StatelessWidget {
  final List<Map<String, String>> foodlists = [
    {'name': 'Apple', 'image': 'assets/apple.jpg', 'description': 'Delicious red apple'},
    {'name': 'Banana', 'image': 'assets/banana.jpg', 'description': 'Fresh yellow banana'},
    {'name': 'Cherry', 'image': 'assets/cherry.jpg', 'description': 'Sweet red cherry'},
    {'name': 'Orange', 'image': 'assets/orange.jpg', 'description': 'Juicy orange'},
    {'name': 'Strawberry', 'image': 'assets/strawberry.jpg', 'description': 'Fresh strawberries'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('หน้าแรก'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.restaurant_menu),
              title: Text('ออเดอร์ของฉัน'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/recipes'); // Adjust route if needed
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('สิ่งที่ถูกใจ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/favorites');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('โปรไฟล์'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.motorcycle),
              title: Text('สมัครไรเดอร์'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/raider');
              },
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('เปิดร้านอาหาร'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/store');
              },
            ),
            ListTile(
              leading: Icon(Icons.support),
              title: Text('แจ้งปัญหา'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/support');
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: foodlists.length,
        itemBuilder: (context, index) {
          final food = foodlists[index];
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Adjust margin as per your design
            child: ListTile(
              contentPadding: EdgeInsets.all(8), // Adjust padding as per your design
              leading: Image.asset(
                food['image']!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              title: Text(food['name']!),
              subtitle: Text(food['description']!),
            ),
          );
        },
      ),
    );
  }
}
