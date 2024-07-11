import 'dart:async';

import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/data/models/my_model.dart';
import 'package:money_manager_clone/feature/presentation/screens/main/cubit/main_cubit.dart';
import 'package:money_manager_clone/feature/presentation/themes/fonts.dart';

import '../../../data/datasources/my_storage.dart';
import '../../../data/models/my_enums.dart';
import '../../themes/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  late MainCubit mainCubit;

  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    ExpenseStorage.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mainCubit = context.read<MainCubit>();

    return BlocProvider(
      create: (context) => mainCubit,
      child: BlocBuilder<MainCubit, MainState>(
        buildWhen: (pr, cr) => pr.loadState != cr.loadState,
        builder: (blocContext, state) {
          selectedDate = state.selectedTime == null
              ? DateTime(DateTime.now().year, DateTime.now().month)
              : state.selectedTime!;

          return Scaffold(
            appBar: AppBar(
              title: const Text("Money manager clone"),
              leading: IconButton(
                onPressed: () {
                  // Search screen
                  Navigator.pushNamed(context, '/search');
                },
                icon: const Icon(Icons.search, size: 26),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    // month and year picker
                  },
                  icon: const Icon(Icons.calendar_month, size: 26),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 4,
                    right: 4,
                    bottom: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        splashColor: AppColors.grey,
                        highlightColor: AppColors.grey,
                        onTap: () async {
                          // month and year picker
                          await _openMonthPicker();
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                selectedDate.year.toString(),
                                style: pregular.copyWith(
                                  fontSize: 12,
                                  color: AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Row(
                                children: [
                                  Text(
                                    convertDate3(
                                        selectedDate.toIso8601String()),
                                    style: psemibold.copyWith(
                                      fontSize: 16,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    "▼",
                                    style: pregular.copyWith(
                                      fontSize: 12,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Income".tr,
                                  style: pregular.copyWith(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AnimatedDigitWidget(
                                  value: state.currentMonthIncome,
                                  enableSeparator: true,
                                  separateSymbol: " ",
                                  textStyle: pmedium.copyWith(
                                    color: AppColors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                /*Text(
                              separateBalance(
                                  state.currentMonthIncome.toString()),
                              style: pmedium.copyWith(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),*/
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Expense".tr,
                                  style: pregular.copyWith(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AnimatedDigitWidget(
                                  value: state.currentMonthExpense,
                                  enableSeparator: true,
                                  separateSymbol: " ",
                                  textStyle: pmedium.copyWith(
                                    color: AppColors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Balance".tr,
                                  style: pregular.copyWith(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AnimatedDigitWidget(
                                  value: state.currentMonthBalance,
                                  enableSeparator: true,
                                  separateSymbol: " ",
                                  textStyle: pmedium.copyWith(
                                    color: AppColors.black,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (state.loadState == LoadState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.dayModels.isEmpty) {
                    return Center(
                      child: Image.asset(
                        'empty3'.pngIcon,
                        width: 140,
                        height: 140,
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.dayModels.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, dayIndex) {
                      final dayModels = state.dayModels;
                      final expenseModels =
                          dayModels[dayIndex].listExpenseModel;

                      final expense = calculateExpense(
                          dayModels[dayIndex].listExpenseModel);
                      final income =
                          calculateIncome(dayModels[dayIndex].listExpenseModel);

                      return Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  right: 12,
                                  top: 8,
                                  bottom: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      convertDate(dayModels[dayIndex]
                                          .dayTime
                                          .toIso8601String()),
                                      style: pmedium.copyWith(fontSize: 12),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${"Expense".tr}: $expense",
                                          style: pregular.copyWith(
                                            fontSize: 12,
                                            color: context.isDarkThemeMode
                                                ? AppColors.white
                                                : Colors.black45,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "${"Income".tr}: $income",
                                          style: pregular.copyWith(
                                            fontSize: 12,
                                            color: context.isDarkThemeMode
                                                ? AppColors.white
                                                : Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(height: 1, color: Colors.grey.shade300),
                            ],
                          ),
                          ListView.builder(
                            itemCount: expenseModels.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, modelIndex) {
                              return InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  final needRefresh = await Navigator.pushNamed(
                                    context,
                                    '/detail',
                                    arguments: expenseModels[modelIndex].id,
                                  );
                                  if (needRefresh != null) {
                                    await refresh();
                                  }
                                },
                                child: expanseItem(expenseModels[modelIndex]),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final needRefresh = await Navigator.pushNamed(
                  context,
                  '/add',
                  arguments: null,
                );
                if (needRefresh != null) {
                  await refresh();
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: Colors.orangeAccent,
              child: const Icon(Icons.add, color: AppColors.black),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openMonthPicker() async {
    final firstDate = DateTime.now().year - 2;
    final lastDate = DateTime.now().year + 2;
    final currentDate = selectedDate;

    final DateTime? selected = await showMonthPicker(
      context: context,
      initialDate: mainCubit.state.selectedTime ?? DateTime.now(),
      firstDate: DateTime(firstDate),
      lastDate: DateTime(lastDate),
      builder: (context, child) {
        final themeData = ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.orange,
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
    if (selected != null && currentDate != selected) {
      mainCubit.changeDateTime(DateTime(selected.year, selected.month));
      await refresh();
    }
  }

  Future<void> refresh() async {
    await mainCubit.refreshData();
  }

  int calculateExpense(List<ExpenseModel> list) {
    int expense = 0;
    list.map((model) {
      if (model.type == "Expense") {
        expense += model.number;
      }
    }).toList();
    return expense;
  }

  int calculateIncome(List<ExpenseModel> list) {
    int income = 0;
    list.map((model) {
      if (model.type == "Income") {
        income += model.number;
      }
    }).toList();
    return income;
  }

  Widget expanseItem(ExpenseModel model) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              final needRefresh =
                  await Navigator.pushNamed(context, '/add', arguments: model);
              if (needRefresh != null) {
                await refresh();
              }
            },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          ),
          SlidableAction(
            onPressed: (context) async {
              await mainCubit.deleteModel(model.id ?? -1);
              await refresh();
            },
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
      child: Card(
        elevation: 1,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: ColoredBox(
                  color: AppColors.orange,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      model.icon.svgIcon,
                      width: 30,
                      height: 30,
                      colorFilter: const ColorFilter.mode(
                        Colors.black87,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  model.note.isEmpty ? model.title : model.note,
                  style: pregular.copyWith(
                    fontSize: 14,
                    color: Theme.of(context).canvasColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                separateBalance(model.number.toString()),
                style: pmedium.copyWith(
                  fontSize: 14,
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
