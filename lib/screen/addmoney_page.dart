import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:seafood_app/screen/food_app.dart';

class AddMoneyPage extends StatefulWidget {
  const AddMoneyPage({Key? key}) : super(key: key);

  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  final List<int> amounts = [10, 20, 50, 100, 200, 500, 1000];
  int? selectedAmount;
  File? selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadData() async {
    try {
      // Get current user ID
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw 'User not logged in';
      }

      // Upload the slip image to Firebase Storage
      String imageUrl = '';
      if (selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('payment_slips/${user.uid}/${DateTime.now().toIso8601String()}');
        await storageRef.putFile(selectedImage!);
        imageUrl = await storageRef.getDownloadURL();
      }

      // Fetch the current balance from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      double currentBalance = (userDoc['balance'] ?? 0).toDouble();

      // Update the balance with the selected amount
      double newBalance = currentBalance + (selectedAmount ?? 0);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'balance': newBalance,
      });

      // Save transaction data to Firestore in the user's collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .add({
        'amount': selectedAmount,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Display a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('การเติมเงินสำเร็จ!')),
      );

      // Navigate back to the FoodApp page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => FoodApp()),
        (route) => false,
      ); // Clears the stack and navigates to the FoodApp page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการชำระเงิน'),
          content: const Text('ท่านต้องการชำระเงินหรือไม่?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('ยืนยัน'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _uploadData(); // Proceed with the data upload
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เติมเงินเข้าสู่ระบบ"),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FoodApp()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'เลือกจำนวนเงิน:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: selectedAmount,
                    hint: const Text('กรุณาเลือกจำนวนเงิน'),
                    items: amounts.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value บาท'),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedAmount = newValue;
                      });
                    },
                    underline: const SizedBox(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'อัพโหลดสลิปเงิน:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _pickImage,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('เลือกไฟล์สลิป'),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Center(child: Text('ยังไม่ได้อัพโหลดสลิป', textAlign: TextAlign.center)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Payment Instructions Section
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      border: Border.all(color: Colors.teal),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.info, color: Colors.teal),
                            SizedBox(width: 8),
                            Text(
                              'กรุณาชำระตามยอดที่ท่านเลือก',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'บัญชี 4400767701 กรุงไทย (นาย อิราธิวัฒน์ บันโสภา)',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      if (selectedAmount != null && selectedImage != null) {
                        _showConfirmationDialog();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('กรุณาเลือกจำนวนเงินและอัพโหลดสลิป')),
                        );
                      }
                    },
                    child: const Text('ยืนยันการเติมเงิน', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
