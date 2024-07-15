import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/data/models/my_enums.dart';
import 'package:money_manager_clone/feature/presentation/screens/main/cubit/main_cubit.dart';
import 'package:money_manager_clone/feature/presentation/themes/fonts.dart';

import '../../themes/colors.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  final GlobalKey _menuKeyLang = GlobalKey();

  late MainCubit mainCubit;

  bool isYear = false;

  final List<String> types = ["Expense".tr, "Income".tr];

  @override
  Widget build(BuildContext context) {
    mainCubit = context.read<MainCubit>();

    return BlocProvider(
      create: (context) => mainCubit,
      child: BlocBuilder<MainCubit, MainState>(
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
                child: PopupMenuButton<String>(
                  surfaceTintColor: AppColors.transparent,
                  shadowColor: AppColors.transparent,
                  key: _menuKeyLang,
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    "${state.moneyType.tr} ▼",
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
                          choice.tr,
                          style: pmedium.copyWith(fontSize: 14),
                        ),
                      );
                    }).toList();
                  },
                  onSelected: (value) async {
                    debugPrint(value);
                    if (value != state.moneyType.tr) {
                      if (types[0] == value) {
                        mainCubit.changeType("Expense");
                      } else {
                        mainCubit.changeType("Income");
                      }
                      await mainCubit.getAllTypeModels(false);
                    }
                  },
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    bottom: 16,
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color: Colors.black,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    isYear = false;
                                  });
                                  await mainCubit.getAllTypeModels(isYear);
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isYear
                                        ? AppColors.transparent
                                        : Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Month".tr,
                                    style: pregular.copyWith(
                                      fontSize: 16,
                                      color: isYear
                                          ? Colors.black
                                          : const Color(AppColors.orange),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    isYear = true;
                                  });
                                  await mainCubit.getAllTypeModels(isYear);
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isYear
                                        ? Colors.black
                                        : AppColors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Year".tr,
                                    style: pregular.copyWith(
                                      fontSize: 16,
                                      color: isYear
                                          ? const Color(AppColors.orange)
                                          : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${"Total".tr}:",
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
                    ],
                  ),
                ),
              ),
            ),
            body: Builder(
              builder: (context) {
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
                return ListView.builder(
                  itemCount: state.list.length,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  itemBuilder: (context, index) {
                    final model = state.list[index];
                    return Card(
                      elevation: 1,
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                                    color: const Color(AppColors.orange),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        model.icon.svgIcon,
                                        width: 20,
                                        height: 20,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.black87,
                                          BlendMode.srcIn,
                                        ),
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
