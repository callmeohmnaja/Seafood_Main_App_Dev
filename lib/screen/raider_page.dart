import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seafood_app/model/profile.dart';
import 'package:seafood_app/screen/favorites_page.dart';
import 'package:seafood_app/screen/food_oderpage.dart';
import 'package:seafood_app/screen/home.dart';
import 'package:seafood_app/screen/mainhome_page.dart';
import 'package:seafood_app/screen/oder.dart';
import 'package:seafood_app/screen/profile.dart';
import 'package:seafood_app/screen/store_page.dart';
import 'package:seafood_app/screen/support_page.dart';

// ignore: use_key_in_widget_constructors
class RaiderPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  // ignore: unnecessary_new
  Profile profile = new Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สมัครไรเดอร์'),
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
              onTap: () => _navigateTo(context, FoodOrderPage()),
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
                'สมัครเป็นไรเดอร์',
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
                          'กรุณากรอกข้อมูลของคุณ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildTextField(
                          label: 'ชื่อ',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกชื่อ';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          label: 'อีเมล',
                          icon: Icons.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกอีเมล';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'กรุณากรอกอีเมลที่ถูกต้อง';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          label: 'เบอร์โทรศัพท์',
                          icon: Icons.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกเบอร์โทรศัพท์';
                            }
                            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                              return 'กรุณากรอกเบอร์โทรศัพท์ที่ถูกต้อง';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          label: 'เลขใบอนุญาตขับขี่',
                          icon: Icons.card_membership,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกเลขใบอนุญาตขับขี่';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              // Handle form submission here
                            }
                          },
                          // ignore: sort_child_properties_last
                          child: Text('สมัคร'),
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

  Widget _buildTextField({
    required String label,
    required IconData icon,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon, color: Colors.green),
      ),
      validator: validator,
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