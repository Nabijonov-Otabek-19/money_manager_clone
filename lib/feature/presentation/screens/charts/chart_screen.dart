import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/presentation/screens/charts/cubit/chart_cubit.dart';
import 'package:money_manager_clone/feature/presentation/themes/fonts.dart';

import '../../themes/colors.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final cubit = ChartCubit();

  final GlobalKey _menuKeyLang = GlobalKey();

  final List<String> types = ["Expense", "Income"];

  @override
  void initState() {
    cubit.getAllTypeModels();
    super.initState();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<ChartCubit, ChartState>(
        buildWhen: (pr, cr) =>
            pr.loadState != cr.loadState || pr.moneyType != cr.moneyType,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: InkWell(
                highlightColor: AppColors.transparent,
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // show menu button
                  dynamic state = _menuKeyLang.currentState;
                  state
                      .showButtonMenu(); // This opens the dropdown menu programmatically.
                },
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: PopupMenuButton<String>(
                    surfaceTintColor: AppColors.transparent,
                    shadowColor: AppColors.transparent,
                    key: _menuKeyLang,
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "${state.moneyType} ▼",
                      style: pmedium.copyWith(
                        fontSize: 16,
                        color:
                            Theme.of(context).appBarTheme.titleTextStyle?.color,
                      ),
                    ),
                    itemBuilder: (context) {
                      return types.map((choice) {
                        return PopupMenuItem(
                          value: choice,
                          child: Text(
                            choice,
                            style: pmedium.copyWith(fontSize: 14),
                          ),
                        );
                      }).toList();
                    },
                    onSelected: (value) async {
                      if (value != state.moneyType) {
                        cubit.changeType(value);
                        await cubit.getAllTypeModels();
                      }
                    },
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total:",
                        style: pmedium.copyWith(
                          fontSize: 16,
                          color: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle
                              ?.color,
                        ),
                      ),
                      Text(
                        separateBalance(state.totalExpense.toString()),
                        style: pmedium.copyWith(
                          fontSize: 16,
                          color: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle
                              ?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Builder(
              builder: (context) {
                if (state.list.isEmpty) {
                  return Center(
                    child: Image.asset(
                      'empty3'.pngIcon,
                      width: 140,
                      height: 140,
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: ListView.builder(
                    itemCount: state.list.length,
                    itemBuilder: (context, index) {
                      final model = state.list[index];
                      return Card(
                        elevation: 1,
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: ColoredBox(
                                      color: AppColors.orange,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                          model.icon.svgIcon,
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    model.title,
                                    style: pregular.copyWith(fontSize: 14),
                                  ),
                                ],
                              ),
                              Text(
                                separateBalance(model.number.toString()),
                                style: pregular.copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
