import 'package:flutter/material.dart';
import 'menu.dart';

class BookPage extends StatelessWidget {
  final Book book;
  // ignore: use_super_parameters
  const BookPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Image.network(book.urlImages,width: double.infinity,
      height: 300,
      fit: BoxFit.contain,
      ),
    );
  }
  }
