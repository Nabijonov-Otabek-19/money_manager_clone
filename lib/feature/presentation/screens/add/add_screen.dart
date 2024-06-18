import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/presentation/screens/add/cubit/add_cubit.dart';
import 'package:money_manager_clone/feature/presentation/themes/colors.dart';

import '../../../data/models/my_model.dart';
import '../../themes/fonts.dart';

class AddScreen extends StatefulWidget {
  final ExpenseModel? model;

  const AddScreen({super.key, required this.model});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController noteController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  final cubit = AddCubit();
  int currentIndex = -1;
  String type = "Expense";
  bool isExpense = true;

  final titleList = [
    "Snack",
    "Health",
    "Food",
    "Beauty",
    "Transportation",
    "Education",
  ];
  final iconList = [
    "snack",
    "health",
    "food",
    "beauty",
    "transportation",
    "education",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      noteController.text = widget.model!.note;
      amountController.text = widget.model!.number.toString();
      currentIndex = checkType(widget.model!.type);
    }
  }

  int checkType(String type) {
    Map<String, int> typeMap = {
      "Snack": 0,
      "Health": 1,
      "Food": 2,
      "Beauty": 3,
      "Transportation": 4,
      "Education": 5,
      "Settings": 6,
    };

    return typeMap[type] ?? 0;
  }

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
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              splashColor: AppColors.transparent,
                              highlightColor: AppColors.transparent,
                              onTap: () {
                                setState(() {
                                  if (!isExpense) {
                                    isExpense = true;
                                    type = "Expense";
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.black,
                                    width: 1,
                                  ),
                                  color: isExpense
                                      ? AppColors.orange
                                      : AppColors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Expense",
                                    style: pregular.copyWith(
                                      fontSize: 12,
                                      color: AppColors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              splashColor: AppColors.transparent,
                              highlightColor: AppColors.transparent,
                              onTap: () {
                                setState(() {
                                  if (isExpense) {
                                    isExpense = false;
                                    type = "Income";
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.black,
                                    width: 1,
                                  ),
                                  color: isExpense
                                      ? AppColors.white
                                      : AppColors.orange,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Income",
                                    style: pregular.copyWith(
                                      fontSize: 12,
                                      color: AppColors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
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
                        labelText: "Note",
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

                        if (widget.model == null) {
                          // Add
                          if (number.isNotEmpty && currentIndex != -1) {
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
                        } else {
                          // Edit
                          if (number.isNotEmpty && currentIndex != -1) {
                            await cubit.editModel(ExpenseModel(
                              id: widget.model!.id,
                              title: title,
                              icon: icon,
                              number: int.tryParse(number) ?? 0,
                              type: type,
                              note: note,
                              //createdTime: DateTime.now(),
                              createdTime: widget.model!.createdTime,
                              photo: "",
                            ));
                          }
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
                            widget.model == null ? "Save" : "Update",
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
