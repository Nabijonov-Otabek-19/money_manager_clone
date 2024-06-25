import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/data/models/my_model.dart';
import 'package:money_manager_clone/feature/presentation/screens/home/cubit/home_cubit.dart';
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
  final cubit = HomeCubit();

  TextEditingController titleController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit.refreshData();
  }

  @override
  void dispose() {
    ExpenseStorage.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (pr, cr) => pr.loadState != cr.loadState,
        builder: (blocContext, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Money manager clone"),
              leading: IconButton(
                onPressed: () {
                  //
                },
                icon: const Icon(Icons.search, size: 26),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    //
                  },
                  icon: const Icon(Icons.calendar_month, size: 26),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Income",
                            style: pregular.copyWith(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            separateBalance(
                                state.currentMonthIncome.toString()),
                            style: pmedium.copyWith(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Expenses",
                            style: pregular.copyWith(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            separateBalance(
                                state.currentMonthExpense.toString()),
                            style: pmedium.copyWith(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Balance",
                            style: pregular.copyWith(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            separateBalance(
                                state.currentMonthBalance.toString()),
                            style: pmedium.copyWith(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
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
                  if (state.list.isEmpty) {
                    return Center(
                      child: Image.asset(
                        'empty3'.pngIcon,
                        width: 140,
                        height: 140,
                      ),
                    );
                  }

                  final monthModels = state.list.first;

                  return ListView.builder(
                    itemCount: state.list.first.listDayModel.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, dayIndex) {
                      final dayModels = monthModels.listDayModel;
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
                                  bottom: 8,
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
                                          "Expense: $expense",
                                          style: pregular.copyWith(
                                            fontSize: 12,
                                            color: context.isDarkThemeMode
                                                ? AppColors.white
                                                : Colors.black45,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "Income: $income",
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
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    'detail',
                                    arguments: expenseModels[modelIndex].id,
                                  ).whenComplete(
                                    () async => await cubit.refreshData(),
                                  );
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
                Navigator.pushNamed(context, '/add', arguments: null)
                    .whenComplete(
                  () async => await cubit.refreshData(),
                );
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
            onPressed: (context) {
              Navigator.pushNamed(context, '/add', arguments: model)
                  .whenComplete(
                () async => await cubit.refreshData(),
              );
            },
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.white,
            //icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) async {
              await cubit.deleteModel(model.id ?? -1);
              await cubit.refreshData();
            },
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            // icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        elevation: 1.2,
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
