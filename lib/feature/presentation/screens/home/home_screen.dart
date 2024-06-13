import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/presentation/screens/home/cubit/home_cubit.dart';
import 'package:money_manager_clone/feature/presentation/themes/fonts.dart';

import '../../../data/datasources/my_storage.dart';

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
              title: Text("Home".tr),
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
                  return ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Expenses",
                              style: pmedium.copyWith(
                                fontSize: 20,
                                color: Theme.of(context)
                                    .appBarTheme
                                    .titleTextStyle
                                    ?.color,
                              ),
                            ),
                          ),
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
                                      arguments: item,
                                    ).whenComplete(
                                      () async => await cubit.refreshData(),
                                    );
                                  },
                                  child: expanseItem(
                                    item.icon,
                                    item.note.isEmpty ? item.title : item.note,
                                    item.number,
                                  ),
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
                      ),
                    ),
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/add').whenComplete(
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

  Widget expanseItem(String icon, String title, int expense) {
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                color: Colors.green.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    icon.svgIcon,
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
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
              expense.toString(),
              style: pmedium.copyWith(
                fontSize: 14,
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
