import 'package:flutter/material.dart';
import 'package:seafood_app/screen/rider_settings_page.dart';

class RiderDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้ารายการไรเดอร์'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'ยินดีต้อนรับ ไรเดอร์',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildDashboardCard(
                icon: Icons.assignment,
                title: 'ดูออเดอร์ที่ต้องส่ง',
                onTap: () {},
              ),
              SizedBox(height: 10),
              _buildDashboardCard(
                icon: Icons.history,
                title: 'ดูประวัติการส่ง',
                onTap: () {},
              ),
              SizedBox(height: 10),
              _buildDashboardCard(
                icon: Icons.settings,
                title: 'ตั้งค่าบัญชี',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RiderSettingsPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required GestureTapCallback onTap,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 40, color: Colors.green),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}