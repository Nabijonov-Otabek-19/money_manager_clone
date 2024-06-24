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

class _AddScreenState extends State<AddScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController noteController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  late TabController _tabController;

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
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    if (widget.model != null) {
      noteController.text = widget.model!.note;
      amountController.text = widget.model!.number.toString();
      currentIndex = checkType(widget.model!.type);
      isExpense = widget.model!.type == "Expense" ? true : false;
    }
  }

  void _handleTabChange() {
    int currentIndex = _tabController.index;
    if (currentIndex == 0) {
      type = "Expense";
      isExpense = true;
    } else {
      type = "Income";
      isExpense = false;
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
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  height: 35,
                  margin: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.black, width: 1),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    onTap: (value) {
                      debugPrint(value.toString());
                      if (value == 0) {
                        type = "Expense";
                        isExpense = true;
                      } else {
                        type = "Income";
                        isExpense = false;
                      }
                    },
                    labelStyle: pregular.copyWith(
                      fontSize: 14,
                      color: AppColors.orange,
                    ),
                    unselectedLabelStyle: pregular.copyWith(
                      fontSize: 14,
                      color: AppColors.black,
                    ),
                    tabAlignment: TabAlignment.fill,
                    indicator: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.black, width: 1),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: AppColors.transparent,
                    overlayColor:
                        const WidgetStatePropertyAll(AppColors.transparent),
                    tabs: const [
                      Tab(text: "Expense"),
                      Tab(text: "Income"),
                    ],
                  ),
                ),
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
                        controller: _tabController,
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
                                    currentIndex = index;
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
                                    currentIndex = index;
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
                        final title = isExpense
                            ? titleList[currentIndex]
                            : titleList2[currentIndex];
                        final icon = isExpense
                            ? iconList[currentIndex]
                            : iconList2[currentIndex];

                        if (widget.model == null) {
                          // Add expense
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
                          // Edit expense
                          if (number.isNotEmpty && currentIndex != -1) {
                            await cubit.editModel(ExpenseModel(
                              id: widget.model!.id,
                              title: title,
                              icon: icon,
                              number: int.tryParse(number) ?? 0,
                              type: type,
                              note: note,
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
            color: currentIndex == index
                    ? AppColors.orange
                    : Colors.grey.shade400,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                icon.svgIcon,
                width: 30,
                height: 30,
                colorFilter: ColorFilter.mode(
                  Colors.grey.shade700,
                  BlendMode.srcIn,
                ),
              ),
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
