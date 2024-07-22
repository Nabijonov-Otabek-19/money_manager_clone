import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_clone/feature/presentation/screens/detail/cubit/detail_cubit.dart';
import 'package:money_manager_clone/feature/presentation/themes/colors.dart';

import '../../themes/fonts.dart';

class DetailScreen extends StatefulWidget {
  final int modelId;

  const DetailScreen({super.key, required this.modelId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final cubit = DetailCubit();

  Object? needRefresh;

  @override
  void initState() {
    cubit.getModelById(widget.modelId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) {
            Navigator.pop(context, needRefresh);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Details".tr),
          ),
          body: BlocBuilder<DetailCubit, DetailState>(
            buildWhen: (pr, cr) => pr.loadState != cr.loadState,
            builder: (context, state) {
              if (state.model == null) {
                return Center(
                  child: Text(
                    "Empty".tr,
                    style: pmedium.copyWith(
                      fontSize: 30,
                      color:
                          Theme.of(context).appBarTheme.titleTextStyle?.color,
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: ColoredBox(
                            color:
                                Color(state.model?.color ?? AppColors.orange),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                state.model!.icon.svgIcon,
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
                        Text(
                          state.model!.title,
                          style: pregular.copyWith(
                            fontSize: 18,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Type".tr,
                          style: pmedium.copyWith(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          state.model!.type,
                          style: pregular.copyWith(
                            fontSize: 18,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount".tr,
                          style: pmedium.copyWith(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          separateBalance(state.model!.number.toString()),
                          style: pregular.copyWith(
                            fontSize: 18,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date".tr,
                          style: pmedium.copyWith(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          convertDateTime(state.model!.createdTime),
                          style: pregular.copyWith(
                            fontSize: 18,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Note".tr,
                          style: pmedium.copyWith(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          state.model!.note,
                          style: pregular.copyWith(
                            fontSize: 18,
                            color: Theme.of(context).canvasColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Photo".tr,
                          style: pmedium.copyWith(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 14),
                        state.model?.photo != null && state.model?.photo != ""
                            ? Image.file(
                                File(state.model?.photo ?? ""),
                                width: 150,
                                height: 150,
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(height: 4),
                    const Divider(
                      height: 8,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              // Edit model
                              needRefresh = await Navigator.pushNamed(
                                context,
                                '/add',
                                arguments: state.model!,
                              );

                              if (needRefresh != null) {
                                await cubit.getModelById(widget.modelId);
                              }
                            },
                            child: Text(
                              "Edit".tr,
                              style: pregular.copyWith(
                                fontSize: 16,
                                color: Theme.of(context).canvasColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              await _openSimpleDialog(state.model?.id ?? -1);
                              if (context.mounted) Navigator.pop(context, true);
                            },
                            child: Text(
                              "Delete".tr,
                              style: pregular.copyWith(
                                fontSize: 16,
                                color: Theme.of(context).canvasColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _openSimpleDialog(int modelId) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          surfaceTintColor: AppColors.transparent,
          backgroundColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Attention".tr,
            style: pmedium.copyWith(
              fontSize: 18,
              color: Theme.of(context).canvasColor,
            ),
            textAlign: TextAlign.center,
          ),
          children: [
            const SizedBox(height: 20),
            Text(
              "Delete_data_msg".tr,
              style: pregular.copyWith(
                fontSize: 16,
                color: Theme.of(context).canvasColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      await cubit.deleteModel(modelId);
                      if (context.mounted) Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      minimumSize: const WidgetStatePropertyAll(
                        Size.fromHeight(45),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: Text(
                      "Delete".tr,
                      style: pregular.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      minimumSize: const WidgetStatePropertyAll(
                        Size.fromHeight(45),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    child: Text(
                      "Cancel".tr,
                      style: pregular.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).canvasColor,
                      ),
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

  String convertDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
