import 'package:flutter/material.dart';

class RaiderDashboard extends StatefulWidget {
  const RaiderDashboard({super.key});

  @override
  State<RaiderDashboard> createState() => _RaiderDashboardState();
}

class _RaiderDashboardState extends State<RaiderDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ไรเดอร์'),
      ),
    );
  }
}
