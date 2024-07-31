class Book {
  final String title;
  final String urlImages;

  const Book({
    required this.title,
    required this.urlImages,
  });
}

const allBook = [
  Book(
      title: 'ส้มต้มแซบๆ',
      urlImages:
          'https://f.ptcdn.info/457/080/000/rtr3pk1uuh69g6yUBOqkp-o.jpg'),
  Book(
      title: 'test',
      urlImages:
          'https://f.ptcdn.info/457/080/000/rtr3pk1uuh69g6yUBOqkp-o.jpg'),
  Book(
      title: 'hello',
      urlImages: 'https://f.ptcdn.info/457/080/000/rtr3pk1uuh69g6yUBOqkp-o.jpg')

  //todo เพิ่มเมนูอาหาร,รูปภาพ
];
