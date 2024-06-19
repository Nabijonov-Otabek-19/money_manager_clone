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
  final titleList2 = [
    "Salary",
    "Investment",
    "Awards",
    "Others",
  ];

  final iconList = [
    "snack",
    "health",
    "food",
    "beauty",
    "transportation",
    "education",
  ];
  final iconList2 = [
    "salary",
    "investment",
    "awards",
    "others",
  ];

  Map<String, int> expenseTypeMap = {
    "Snack": 0,
    "Health": 1,
    "Food": 2,
    "Beauty": 3,
    "Transportation": 4,
    "Education": 5,
    "Settings": 6,
  };

  Map<String, int> incomeTypeMap = {
    "Salary": 0,
    "Investment": 1,
    "Awards": 2,
    "Others": 3,
  };

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
    if (type == "Expense") {
      return expenseTypeMap[type] ?? 0;
    } else {
      return incomeTypeMap[type] ?? 0;
    }
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
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Add"),
                centerTitle: true,
                bottom: TabBar(
                  onTap: (value) {
                    if (value == 0) {
                      type = "Expense";
                    } else {
                      type = "Income";
                    }
                  },
                  labelStyle: pregular.copyWith(
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                  unselectedLabelStyle: pregular.copyWith(
                    fontSize: 14,
                    color: AppColors.black,
                  ),
                  tabAlignment: TabAlignment.fill,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.black, width: 1),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: AppColors.transparent,
                  indicatorPadding: const EdgeInsets.symmetric(vertical: 6),
                  overlayColor:
                      const WidgetStatePropertyAll(AppColors.transparent),
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  tabs: const [
                    Tab(text: "Expense"),
                    Tab(text: "Income"),
                  ],
                ),
                leading: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: pregular.copyWith(color: Colors.black, fontSize: 16),
                  ),
                ),
                leadingWidth: 80,
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Expanded(
                        child: TabBarView(
                          children: [
                            GridView.builder(
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
                            GridView.builder(
                              itemCount: titleList2.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                final title = titleList2[index];
                                final icon = iconList2[index];

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
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: noteController,
                        keyboardType: TextInputType.text,
                        decoration: _inputDecoration("Note"),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [MoneyTextFormatter()],
                        decoration: _inputDecoration("Number"),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final note = noteController.text.toString().trim();
                          final number = amountController.text
                              .toString()
                              .trim()
                              .replaceAll(" ", "");
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
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: pregular.copyWith(
        fontSize: 14,
        color: Colors.grey,
      ),
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 0.8),
        borderRadius: BorderRadius.circular(10),
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
