class Profile {
  String? email;
  String? password;
  String? username;
  String? role;
  String? passwordConfirm;
  String? contactNumber;
  String? fullname;
  String? faculty;
  String? department;

  String address;
  String phone;
  String vehicle;
  String menu;
  String customUid;

  // Constructor ที่มีค่าพรีดีฟอลต์ให้ฟิลด์อื่นๆ
  Profile({
    this.email,
    this.password,
    this.username,
    this.role,
    this.passwordConfirm,
    this.address = '', // ค่าพรีดีฟอลต์
    this.phone = '', // ค่าพรีดีฟอลต์
    this.vehicle = '', // ค่าพรีดีฟอลต์
    this.menu = '', // ค่าพรีดีฟอลต์
    this.customUid = '',
  });
}
