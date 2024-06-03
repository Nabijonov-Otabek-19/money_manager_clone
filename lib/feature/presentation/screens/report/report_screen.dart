import 'package:flutter/material.dart';

import '../../themes/fonts.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            "Report screen",
            style: pregular.copyWith(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
