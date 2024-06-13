import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/presentation/screens/add/cubit/add_cubit.dart';
import 'package:money_manager_clone/feature/presentation/themes/colors.dart';

import '../../../data/models/my_model.dart';
import '../../themes/fonts.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController noteController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  final cubit = AddCubit();

  int currentIndex = -1;

  final titleList = [
    "Snack",
    "Health",
    "Food",
    "Beauty",
    "Transportation",
    "Education",
    "Settings",
  ];
  final iconList = [
    "snack",
    "health",
    "food",
    "beauty",
    "transportation",
    "education",
    "setting",
  ];

  @override
  void dispose() {
    noteController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<AddCubit, AddState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Add"),
              centerTitle: true,
              leading: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: pregular.copyWith(color: Colors.black, fontSize: 16),
                ),
              ),
              leadingWidth: 80,
              //toolbarHeight: 100,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        itemCount: titleList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final title = titleList[index];
                          final icon = iconList[index];

                          return GridTile(
                            child: InkWell(
                              splashColor: AppColors.transparent,
                              onTap: () {
                                currentIndex =
                                    currentIndex != index ? index : -1;
                                setState(() {});
                              },
                              child: _buildTypeItem(title, index, icon),
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: noteController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: pregular.copyWith(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Number",
                        labelStyle: pregular.copyWith(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final note = noteController.text.toString().trim();
                        final number = amountController.text.toString().trim();
                        final title = titleList[currentIndex];
                        final icon = iconList[currentIndex];
                        final type = "Expense";

                        if (note.isNotEmpty &&
                            number.isNotEmpty &&
                            currentIndex != -1) {
                          await cubit.addData(ExpenseModel(
                            title: title,
                            icon: icon,
                            number: int.tryParse(number) ?? 0,
                            type: type,
                            note: note,
                            createdTime: DateTime.now(),
                            photo: "",
                          ));
                        }

                        amountController.clear();
                        noteController.clear();

                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            "Save",
                            style: pregular.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeItem(String title, int index, String icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(80),
          child: ColoredBox(
            color: currentIndex == index ? AppColors.orange : AppColors.grey,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(icon.svgIcon, width: 30, height: 30),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: pregular.copyWith(
            fontSize: 12,
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
