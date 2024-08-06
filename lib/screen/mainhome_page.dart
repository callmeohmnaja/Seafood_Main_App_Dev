import 'package:flutter/material.dart';
import 'package:seafood_app/screen/food_app.dart';
import 'package:seafood_app/screen/food_oderpage.dart';
import 'package:seafood_app/screen/home.dart';
import 'package:seafood_app/screen/menu.dart';
import 'package:seafood_app/screen/menu_page.dart';
import 'package:seafood_app/screen/profile.dart';
import 'package:seafood_app/screen/raider_page.dart';
import 'package:seafood_app/screen/store_page.dart';
import 'package:seafood_app/screen/support_page.dart';
import 'book_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();
  List<Book> books = allBook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home')
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodApp()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.restaurant_menu),
              title: Text('ออเดอร์ของฉัน'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodOrderPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('คู่มือการใช้งาน'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoritesPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('โปรไฟล์'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.motorcycle),
              title: Text('สมัครไรเดอร์'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RaiderPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('เปิดร้านอาหาร'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StorePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.support_agent),
              title: Text('แจ้งปัญหา'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('ออกจากระบบ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search TextField
          Container(
            margin: const EdgeInsets.all(16),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.green))),
              onChanged: searchBook,
            ),
          ),
          // Image Carousel
          Container(
            height: 200, // Height of the carousel
            child: PageView(
              children: [
                Image.network(
                  'https://example.com/image1.jpg',
                  fit: BoxFit.cover,
                ),
                Image.network(
                  'https://example.com/image2.jpg',
                  fit: BoxFit.cover,
                ),
                Image.network(
                  'https://example.com/image3.jpg',
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: () {}, child: Text('รถเข็นของฉัน',style: TextStyle(color: Colors.blue))),
              ElevatedButton(onPressed: () {}, child: Text('Text2')),
              ElevatedButton(onPressed: () {}, child: Text('Text3')),
            ],
          ),
          // Book List
          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Image.network(
                    book.urlImages,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(book.title),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookPage(book: book),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void searchBook(String query) {
    final suggestions = allBook.where((book) {
      final bookTitle = book.title.toLowerCase();
      final input = query.toLowerCase();

      return bookTitle.contains(input);
    }).toList();
    
    setState(() => books = suggestions);
  }
}
