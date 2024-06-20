import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/data/models/my_model.dart';
import 'package:money_manager_clone/feature/presentation/screens/home/cubit/home_cubit.dart';
import 'package:money_manager_clone/feature/presentation/themes/fonts.dart';

import '../../../data/datasources/my_storage.dart';
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
                    left: 24,
                    right: 24,
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
                            separateBalance(state.income.toString()),
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
                            separateBalance(state.expense.toString()),
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
                            separateBalance(state.balance.toString()),
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
                      child: Text(
                        "Empty".tr,
                        style: pmedium.copyWith(
                          fontSize: 30,
                          color: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle
                              ?.color,
                        ),
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                          right: 12,
                          top: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Expense",
                              style: pmedium.copyWith(fontSize: 14),
                            ),
                            Text(
                              "DateTime",
                              style: pmedium.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey.shade300),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final item = state.list[index];
                            return InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  'detail',
                                  arguments: item.id,
                                ).whenComplete(
                                  () async => await cubit.refreshData(),
                                );
                              },
                              child: expanseItem(item),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(
                              height: 4,
                              thickness: 0.2,
                              color: Colors.grey,
                            );
                          },
                          itemCount: state.list.length,
                        ),
                      ),
                    ],
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
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
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
        elevation: 2,
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
                    color: Theme.of(context).appBarTheme.titleTextStyle?.color,
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
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
