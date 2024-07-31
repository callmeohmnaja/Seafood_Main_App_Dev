import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final double totalAmount;

  const PaymentPage({Key? key, required this.totalAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ชําระ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'รายจ่ายทั้งหมด: \THB$totalAmount',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'เลือกวิธีการชําระเงิน:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text('Credit/Debit Card'),
              leading: Radio(
                value: 'card',
                groupValue: 'paymentMethod',
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: Text('เก็บเงินปลายทาง'),
              leading: Radio(
                value: 'cash',
                groupValue: 'paymentMethod',
                onChanged: (value) {},
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle payment processing
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('ชําระเงินเสร็จสิ้น!')),
                );
                Navigator.pop(context); // Go back to the cart
              },
              child: Text('ชําระเงิน'),
            ),
          ],
        ),
      ),
    );
  }
}
