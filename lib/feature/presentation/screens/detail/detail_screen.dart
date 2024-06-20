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

  @override
  void initState() {
    cubit.getModel(widget.modelId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Details"),
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
                    color: Theme.of(context).appBarTheme.titleTextStyle?.color,
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
                          color: AppColors.orange,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              state.model!.icon.svgIcon,
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        state.model!.title,
                        style: pregular.copyWith(
                          fontSize: 18,
                          color: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle
                              ?.color,
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
                          color: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle
                              ?.color,
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
                          color: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle
                              ?.color,
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
                          color: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle
                              ?.color,
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
                      Expanded(
                        child: Text(
                          state.model!.note,
                          style: pregular.copyWith(
                            fontSize: 18,
                            color: Theme.of(context)
                                .appBarTheme
                                .titleTextStyle
                                ?.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.end,
                        ),
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
                      Expanded(
                        child: Text(
                          state.model!.photo ?? "",
                          style: pregular.copyWith(
                            fontSize: 18,
                            color: Theme.of(context)
                                .appBarTheme
                                .titleTextStyle
                                ?.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.end,
                        ),
                      ),
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
                          onPressed: () {
                            // Edit model
                            Navigator.pushNamed(
                              context,
                              '/add',
                              arguments: state.model!,
                            ).whenComplete(
                              () async => cubit.getModel(widget.modelId),
                            );
                          },
                          child: Text(
                            "Edit".tr,
                            style: pregular.copyWith(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .appBarTheme
                                  .titleTextStyle
                                  ?.color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            await cubit.deleteModel(state.model!.id ?? -1);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Delete".tr,
                            style: pregular.copyWith(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .appBarTheme
                                  .titleTextStyle
                                  ?.color,
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
    );
  }

  String convertDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
