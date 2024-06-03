import 'package:flutter/material.dart';
import 'package:money_manager_clone/feature/data/models/my_model.dart';
import 'package:intl/intl.dart';

import '../../themes/fonts.dart';

class DetailScreen extends StatefulWidget {
  final ExpenseModel model;

  const DetailScreen({super.key, required this.model});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 20,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ColoredBox(
                    color: Colors.green.shade300,
                    child: const Icon(Icons.add, size: 32),
                  ),
                ),
                Text(
                  widget.model.title,
                  style: pregular.copyWith(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Type",
                  style: pmedium.copyWith(fontSize: 20, color: Colors.grey),
                ),
                Text(
                  widget.model.type,
                  style: pregular.copyWith(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Amount",
                  style: pmedium.copyWith(fontSize: 20, color: Colors.grey),
                ),
                Text(
                  widget.model.number.toString(),
                  style: pregular.copyWith(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date",
                  style: pmedium.copyWith(fontSize: 20, color: Colors.grey),
                ),
                Text(
                  convertDateTime(widget.model.createdTime),
                  style: pregular.copyWith(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Note",
                  style: pmedium.copyWith(fontSize: 20, color: Colors.grey),
                ),
                Text(
                  widget.model.note,
                  style: pregular.copyWith(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
            const Spacer(),
            const Divider(
              height: 8,
              thickness: 1,
              color: Colors.black12,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Edit model
                    },
                    child: Text(
                      "Edit",
                      style: pregular.copyWith(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Delete model
                    },
                    child: Text(
                      "Delete",
                      style: pregular.copyWith(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String convertDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
