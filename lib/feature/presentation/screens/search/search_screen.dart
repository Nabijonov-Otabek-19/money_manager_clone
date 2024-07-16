import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/data/models/my_enums.dart';
import 'package:money_manager_clone/feature/presentation/screens/search/cubit/search_cubit.dart';
import 'package:money_manager_clone/feature/presentation/themes/colors.dart';

import '../../../data/models/my_model.dart';
import '../../themes/fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  final cubit = SearchCubit();

  final List<String> list = ["All".tr, "Expense".tr, "Income".tr];
  int currentIndex = 0;

  @override
  void dispose() {
    cubit.close();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search".tr),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SearchBar(
                      autoFocus: true,
                      controller: searchController,
                      constraints:
                          const BoxConstraints(maxHeight: 50, minHeight: 50),
                      keyboardType: TextInputType.text,
                      elevation: const WidgetStatePropertyAll(1),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      backgroundColor:
                          const WidgetStatePropertyAll(AppColors.white),
                      trailing: [
                        IconButton(
                          onPressed: () {
                            searchController.clear();
                          },
                          icon: const Icon(Icons.clear, color: AppColors.grey),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    splashColor: AppColors.transparent,
                    highlightColor: AppColors.transparent,
                    onTap: () async {
                      final text = searchController.text.trim();
                      if (text.isNotEmpty) {
                        await cubit.searchBy(text, list[currentIndex]);
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(AppColors.blue),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 1,
                            spreadRadius: 1,
                            color: AppColors.grey,
                            offset: Offset(1, 0),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      "${"Type".tr}:",
                      style: pmedium.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ),
                  for (int i = 0; i < list.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        splashColor: AppColors.transparent,
                        highlightColor: AppColors.transparent,
                        onTap: () async {
                          if (currentIndex != i) {
                            setState(() {
                              currentIndex = i;
                            });
                            final text = searchController.text.trim();
                            if (text.isNotEmpty) {
                              await cubit.searchBy(text, list[currentIndex]);
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: currentIndex == i
                                ? Colors.blueAccent.shade700
                                : Colors.lightBlueAccent.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: Center(
                            child: Text(
                              list[i],
                              style: pmedium.copyWith(
                                fontSize: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            BlocBuilder<SearchCubit, SearchState>(
              buildWhen: (pr, cr) => pr.loadState != cr.loadState,
              builder: (context, state) {
                if (state.loadState == LoadState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    buildWhen: (pr, cr) => pr.loadState != cr.loadState,
                    builder: (context, state) {
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
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final model = state.list[index];

                          return InkWell(
                            splashColor: AppColors.transparent,
                            highlightColor: AppColors.transparent,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: model.id,
                              );
                            },
                            child: expanseItem(model),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget expanseItem(ExpenseModel model) {
    return Card(
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
                color: Color(model.color),
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
    );
  }
}
