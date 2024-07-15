import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/presentation/screens/add_edit/cubit/add_edit_cubit.dart';
import 'package:money_manager_clone/feature/presentation/themes/colors.dart';

import '../../../../core/extensions/image_picker_extension.dart';
import '../../../../core/utils/constants.dart';
import '../../../data/models/my_model.dart';
import '../../themes/fonts.dart';

class AddEditScreen extends StatefulWidget {
  final ExpenseModel? model;

  const AddEditScreen({super.key, required this.model});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController noteController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  late TabController _tabController;

  final cubit = AddEditCubit();
  int currentIndex = -1;
  String type = "Expense";
  bool isExpense = true;
  DateTime selectedDateTime = DateTime.now();
  String? photoPath;
  int color = AppColors.orange;

  final ImagePickerService _picker = ImagePickerService();

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
      selectedDateTime = widget.model!.createdTime;
      photoPath = widget.model!.photo;
      color = widget.model!.color;
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
      return expenseTypeMap[widget.model?.title] ?? 0;
    } else {
      return incomeTypeMap[widget.model?.title] ?? 0;
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
      child: BlocBuilder<AddEditCubit, AddEditState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.model == null ? "Add".tr : "Edit".tr),
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
                      color: const Color(AppColors.orange),
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
                    tabs: [
                      Tab(text: "Expense".tr),
                      Tab(text: "Income".tr),
                    ],
                  ),
                ),
              ),
              leading: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel".tr,
                  style: pregular.copyWith(color: Colors.black, fontSize: 16),
                ),
              ),
              leadingWidth: 120,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 12,
                          ),
                          itemCount: titleExpenseList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final title = titleExpenseList[index];
                            final icon = iconExpenseList[index];

                            return GridTile(
                              child: InkWell(
                                splashColor: AppColors.transparent,
                                onTap: () async {
                                  currentIndex = index;
                                  setState(() {});
                                  if (currentIndex != -1) {
                                    await _openAddTextField();
                                  }
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 12,
                          ),
                          itemCount: titleIncomeList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final title = titleIncomeList[index];
                            final icon = iconIncomeList[index];

                            return GridTile(
                              child: InkWell(
                                splashColor: AppColors.transparent,
                                onTap: () async {
                                  currentIndex = index;
                                  setState(() {});
                                  if (currentIndex != -1) {
                                    await _openAddTextField();
                                  }
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openAddTextField() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      builder: (context) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) => Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(80),
                        onTap: () async {
                          await _openPickColorDialog(
                            context,
                            (clr) async {
                              setState(() {
                                color = clr;
                              });
                            },
                          );
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Color(color),
                            borderRadius: BorderRadius.circular(80),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(1, 1),
                                spreadRadius: 1,
                                blurRadius: 1,
                                color: AppColors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(flex: 1),
                      IconButton(
                        onPressed: () async {
                          // pick photo from album or camera
                          await _openPickImageDialog(
                            context,
                            (fromGallery) async {
                              photoPath = await _picker.pickImage(fromGallery);
                              if (photoPath != null) {
                                setState(() {});
                              }
                            },
                          );
                        },
                        icon: photoPath != null && photoPath != ""
                            ? Image.file(
                                File(photoPath ?? ""),
                                width: 30,
                                height: 30,
                              )
                            : Icon(
                                Icons.camera_alt_outlined,
                                size: 26,
                                color: context.isDarkThemeMode
                                    ? Colors.grey
                                    : Colors.black45,
                              ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () async {
                          // set or change date
                          final time = widget.model == null
                              ? DateTime.now()
                              : widget.model!.createdTime;
                          await _openDateTimePicker(
                            time,
                            (pickedDate) {
                              setState(() {
                                selectedDateTime = pickedDate;
                              });
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(AppColors.orange),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            child: Center(
                              child: Text(
                                widget.model == null
                                    ? convertDate2(
                                        selectedDateTime.toIso8601String())
                                    : convertDate2(widget.model!.createdTime
                                        .toIso8601String()),
                                style: pregular.copyWith(
                                  fontSize: 14,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: noteController,
                    keyboardType: TextInputType.text,
                    decoration: _inputDecoration("Note".tr),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [MoneyTextFormatter()],
                    decoration: _inputDecoration("Quantity".tr),
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
                          ? titleExpenseList[currentIndex]
                          : titleIncomeList[currentIndex];
                      final icon = isExpense
                          ? iconExpenseList[currentIndex]
                          : iconIncomeList[currentIndex];

                      if (widget.model == null) {
                        // Add expense
                        if (number.isNotEmpty && currentIndex != -1) {
                          await cubit.addExpense(ExpenseModel(
                            title: title,
                            icon: icon,
                            number: int.tryParse(number) ?? 0,
                            type: type,
                            note: note,
                            createdTime: selectedDateTime,
                            photo: photoPath ?? "",
                            color: color,
                          ));
                        }
                      } else {
                        // Edit expense
                        if (number.isNotEmpty && currentIndex != -1) {
                          await cubit.updateExpense(ExpenseModel(
                            id: widget.model!.id,
                            title: title,
                            icon: icon,
                            number: int.tryParse(number) ?? 0,
                            type: type,
                            note: note,
                            createdTime: selectedDateTime,
                            photo: photoPath ?? "",
                            color: color,
                          ));
                        }
                      }

                      amountController.clear();
                      noteController.clear();

                      if (context.mounted) {
                        Navigator.pop(context);
                        Navigator.pop(context, true);
                      }
                    },
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          widget.model == null ? "Save".tr : "Update".tr,
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
    );
  }

  Future<void> _openPickColorDialog(
    BuildContext ctx,
    Future<void> Function(int) onClick,
  ) async {
    return await showDialog<void>(
      context: ctx,
      builder: (context) {
        return SimpleDialog(
          insetPadding: const EdgeInsets.all(12),
          surfaceTintColor: AppColors.transparent,
          backgroundColor: ctx.isDarkThemeMode
              ? AppColors.scaffoldBackDark
              : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                for (final clr in colorList)
                  InkWell(
                    borderRadius: BorderRadius.circular(80),
                    onTap: () {
                      onClick(clr);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: clr == color
                              ? Colors.black87
                              : AppColors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(80),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(1, 1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            color: AppColors.grey,
                          ),
                        ],
                        color: Color(clr),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _openPickImageDialog(
    BuildContext ctx,
    Future<void> Function(bool) onClick,
  ) async {
    return await showDialog<void>(
      context: ctx,
      builder: (context) {
        return SimpleDialog(
          insetPadding: const EdgeInsets.all(12),
          surfaceTintColor: AppColors.transparent,
          backgroundColor: ctx.isDarkThemeMode
              ? AppColors.scaffoldBackDark
              : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Pick Image",
            style: pbold.copyWith(
              fontSize: 20,
              color: Theme.of(context).canvasColor,
            ),
            textAlign: TextAlign.center,
          ),
          children: [
            const SizedBox(height: 12),
            InkWell(
              splashColor: AppColors.transparent,
              highlightColor: AppColors.transparent,
              onTap: () async {
                // from camera
                onClick(false);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    "Camera",
                    style: pmedium.copyWith(
                      fontSize: 18,
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              splashColor: AppColors.transparent,
              highlightColor: AppColors.transparent,
              onTap: () async {
                // from gallery
                onClick(true);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    "Gallery",
                    style: pmedium.copyWith(
                      fontSize: 18,
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openDateTimePicker(
    DateTime time,
    Function(DateTime) onClick,
  ) async {
    final firstDate = DateTime.now().year - 2;
    final lastDate = DateTime.now().year + 2;
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: time,
      firstDate: DateTime(firstDate),
      lastDate: DateTime(lastDate),
      builder: (context, child) {
        final themeData = ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: const Color(AppColors.orange),
            onPrimary: Colors.white,
            surface:
                context.isDarkThemeMode ? AppColors.black : AppColors.white,
            onSurface: context.isDarkThemeMode ? Colors.white : AppColors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor:
                  context.isDarkThemeMode ? Colors.white : AppColors.black,
            ),
          ),
        );
        return Theme(data: themeData, child: child!);
      },
    );

    if (pickedDateTime != null) {
      onClick(pickedDateTime);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: pregular.copyWith(
        fontSize: 14,
        color: Colors.grey,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
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
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: ColoredBox(
              color: currentIndex == index
                  ? const Color(AppColors.orange)
                  : Colors.grey.shade300,
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
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: pregular.copyWith(
            fontSize: 12,
            color: Theme.of(context).canvasColor,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
