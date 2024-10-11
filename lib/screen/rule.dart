import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package
import 'package:seafood_app/screen/home.dart';

// ignore: use_key_in_widget_constructors
class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: GoogleFonts.prompt(), // Use Google Fonts for the app bar title
        ),
        backgroundColor: Colors.teal,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'ข้อตกลงและกฎบังคับ',
                      style: GoogleFonts.prompt(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '1. บทบาทของผู้ใช้ทั่วไป',
                    style: GoogleFonts.prompt(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• การลงทะเบียน: ผู้ใช้ต้องลงทะเบียนบัญชีผู้ใช้ด้วยข้อมูลที่ถูกต้องและเป็นจริง เช่น ชื่อ, อีเมล, และหมายเลขโทรศัพท์\n'
                    '• การสั่งอาหาร: เมื่อสั่งอาหารแล้ว ผู้ใช้จะต้องชำระเงินตามราคาที่ระบุและไม่สามารถยกเลิกคำสั่งซื้อหรือขอคืนเงินได้หลังจากยืนยันการสั่งซื้อแล้ว\n'
                    '• การชำระเงิน: เงินที่เติมเข้าสู่ระบบแอปพลิเคชันจะไม่สามารถขอคืนได้ทุกกรณี โปรดตรวจสอบยอดเงินและการสั่งซื้อให้ถูกต้องก่อนทำการชำระเงิน\n'
                    '• ข้อร้องเรียน: หากผู้ใช้พบปัญหากับการสั่งซื้ออาหารหรือการบริการ กรุณาติดต่อฝ่ายบริการลูกค้าเพื่อรับการช่วยเหลือ',
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '2. บทบาทของร้านอาหาร',
                    style: GoogleFonts.prompt(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• การลงทะเบียนร้านค้า: ร้านอาหารจะต้องลงทะเบียนและยืนยันข้อมูลธุรกิจ เช่น ชื่อร้าน, ที่อยู่, หมายเลขโทรศัพท์, และเมนูอาหาร\n'
                    '• ความรับผิดชอบในการจัดเตรียมอาหาร: ร้านค้าต้องรับผิดชอบในการจัดเตรียมอาหารให้ตรงตามคำสั่งซื้อและรักษาคุณภาพของอาหารตามมาตรฐานที่กำหนด\n'
                    '• การจัดการเมนู: ร้านค้าสามารถเพิ่ม, แก้ไข, หรือลบรายการอาหารได้ตลอดเวลา แต่ต้องมั่นใจว่าเมนูที่แสดงในแอปพลิเคชันเป็นข้อมูลที่ถูกต้องและเป็นปัจจุบัน\n'
                    '• การยกเลิกคำสั่งซื้อ: ร้านค้าสามารถยกเลิกคำสั่งซื้อได้ในกรณีที่ไม่สามารถจัดเตรียมอาหารได้ แต่ต้องแจ้งให้ผู้ใช้ทราบล่วงหน้า',
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '3. บทบาทของไรเดอร์ส่งอาหาร',
                    style: GoogleFonts.prompt(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• การลงทะเบียน: ไรเดอร์ต้องลงทะเบียนบัญชีและยืนยันข้อมูลส่วนตัว เช่น ชื่อ, หมายเลขโทรศัพท์, และข้อมูลยานพาหนะ\n'
                    '• การรับคำสั่งส่งอาหาร: ไรเดอร์ต้องรับผิดชอบในการรับคำสั่งส่งอาหารจากร้านอาหารและจัดส่งไปยังผู้ใช้ปลายทางตามเวลาที่กำหนด\n'
                    '• ความปลอดภัยในการจัดส่ง: ไรเดอร์ต้องรักษาความสะอาดและความปลอดภัยของอาหารระหว่างการจัดส่ง รวมถึงปฏิบัติตามกฎจราจรและข้อบังคับด้านความปลอดภัยในการขับขี่\n'
                    '• การสื่อสารกับผู้ใช้: ไรเดอร์ควรติดต่อกับผู้ใช้ในกรณีที่พบปัญหาเกี่ยวกับการส่งอาหาร เช่น ไม่สามารถหาที่อยู่ปลายทางได้',
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '4. เงื่อนไขทั่วไป',
                    style: GoogleFonts.prompt(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• การปฏิบัติตามกฎหมาย: ทุกฝ่ายที่เกี่ยวข้องต้องปฏิบัติตามกฎหมายและข้อบังคับที่เกี่ยวข้องกับธุรกิจอาหารและการจัดส่ง\n'
                    '• การปิดบัญชี: แอปพลิเคชันมีสิทธิ์ในการปิดหรือระงับบัญชีของผู้ใช้, ร้านอาหาร, หรือไรเดอร์ ที่ไม่ปฏิบัติตามกฎระเบียบและข้อบังคับ หรือมีการกระทำที่ผิดจรรยาบรรณ\n'
                    '• การเก็บรักษาข้อมูล: ข้อมูลส่วนบุคคลของผู้ใช้ทั้งหมดจะถูกเก็บรักษาอย่างปลอดภัยตามนโยบายความเป็นส่วนตัวของแอปพลิเคชัน และจะไม่ถูกนำไปใช้โดยไม่ได้รับอนุญาตจากผู้ใช้',
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Divider(color: Colors.teal),
                  Text(
                    'การใช้งานแอปพลิเคชันนี้ถือเป็นการยอมรับเงื่อนไขและข้อบังคับทั้งหมด หากผู้ใช้ไม่ยอมรับข้อกำหนดเหล่านี้ ขอให้งดใช้บริการของแอปพลิเคชัน',
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      color: Colors.teal[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
