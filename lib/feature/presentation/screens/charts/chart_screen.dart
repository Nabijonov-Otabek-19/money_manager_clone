import 'package:flutter/material.dart';

import '../../themes/fonts.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chart"),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            "Chart screen",
            style: pregular.copyWith(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
