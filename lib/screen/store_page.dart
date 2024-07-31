// import 'package:flutter/material.dart';
// import 'package:seafood_app/screen/favorites_page.dart';
// import 'package:seafood_app/screen/home.dart';
// import 'package:seafood_app/screen/mainhome_page.dart';
// import 'package:seafood_app/screen/oder.dart';
// import 'package:seafood_app/screen/profile.dart';
// import 'package:seafood_app/screen/raider_page.dart';
// import 'package:seafood_app/screen/support_page.dart';

// // ignore: use_key_in_widget_constructors
// class StorePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('เปิดร้านอาหาร'),
//       ),
//          drawer: Drawer(
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
//                   context, MaterialPageRoute(builder: (context) => HomePage()),
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
//         child: Text('เขียน'),
//       ),
//     );
//   }
// }

// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:seafood_app/screen/favorites_page.dart';
import 'package:seafood_app/screen/home.dart';
import 'package:seafood_app/screen/mainhome_page.dart';
import 'package:seafood_app/screen/oder.dart';
import 'package:seafood_app/screen/profile.dart';
import 'package:seafood_app/screen/support_page.dart';
import 'raider_page.dart';

class StorePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เปิดร้านอาหาร'),
        backgroundColor: Colors.green,
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
            _buildDrawerItem(
              icon: Icons.home,
              text: 'หน้าแรก',
              onTap: () => _navigateTo(context, HomePage()),
            ),
            _buildDrawerItem(
              icon: Icons.restaurant_menu,
              text: 'ออเดอร์ของฉัน',
              onTap: () => _navigateTo(context, RecipesPage()),
            ),
            _buildDrawerItem(
              icon: Icons.favorite,
              text: 'สิ่งที่ถูกใจ',
              onTap: () => _navigateTo(context, FavoritesPage()),
            ),
            _buildDrawerItem(
              icon: Icons.person,
              text: 'โปรไฟล์',
              onTap: () => _navigateTo(context, ProfilePage()),
            ),
            _buildDrawerItem(
              icon: Icons.motorcycle,
              text: 'สมัครไรเดอร์',
              onTap: () => _navigateTo(context, RaiderPage()),
            ),
            _buildDrawerItem(
              icon: Icons.store,
              text: 'เปิดร้านอาหาร',
              onTap: () => _navigateTo(context, StorePage()),
            ),
            _buildDrawerItem(
              icon: Icons.support,
              text: 'แจ้งปัญหา',
              onTap: () => _navigateTo(context, SupportPage()),
            ),
            _buildDrawerItem(
              icon: Icons.logout,
              text: 'ออกจากระบบ',
              onTap: () => _navigateTo(context, HomeScreen()),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'เปิดร้านอาหาร',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'กรุณากรอกข้อมูลร้านอาหาร',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildTextField(
                          label: 'ชื่อร้านอาหาร',
                          icon: Icons.store,
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          label: 'ที่อยู่ร้านอาหาร',
                          icon: Icons.location_on,
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          label: 'เบอร์โทรศัพท์',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          label: 'เวลาทำการ',
                          icon: Icons.access_time,
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          label: 'ประเภทอาหาร',
                          icon: Icons.restaurant,
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          label: 'รายละเอียดเพิ่มเติม',
                          icon: Icons.info,
                          maxLines: 3,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('กำลังบันทึกข้อมูล')),
                              );
                            }
                          },
                          // ignore: sort_child_properties_last
                          child: Text('เปิดร้าน'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกข้อมูล';
        }
        return null;
      },
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(text),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}