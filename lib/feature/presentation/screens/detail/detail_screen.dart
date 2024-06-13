import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:money_manager_clone/core/extensions/my_extensions.dart';
import 'package:money_manager_clone/feature/data/models/my_model.dart';
import 'package:intl/intl.dart';
import 'package:money_manager_clone/feature/presentation/screens/detail/cubit/detail_cubit.dart';

import '../../themes/fonts.dart';

class DetailScreen extends StatefulWidget {
  final ExpenseModel model;

  const DetailScreen({super.key, required this.model});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final cubit = DetailCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Details"),
        ),
        body: Padding(
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
                      color: Colors.green.shade300,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          widget.model.icon.svgIcon,
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.model.title,
                    style: pregular.copyWith(
                      fontSize: 20,
                      color:
                          Theme.of(context).appBarTheme.titleTextStyle?.color,
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
                    style: pmedium.copyWith(fontSize: 20, color: Colors.grey),
                  ),
                  Text(
                    widget.model.type,
                    style: pregular.copyWith(
                      fontSize: 20,
                      color:
                          Theme.of(context).appBarTheme.titleTextStyle?.color,
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
                    style: pmedium.copyWith(fontSize: 20, color: Colors.grey),
                  ),
                  Text(
                    widget.model.number.toString(),
                    style: pregular.copyWith(
                      fontSize: 20,
                      color:
                          Theme.of(context).appBarTheme.titleTextStyle?.color,
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
                    style: pmedium.copyWith(fontSize: 20, color: Colors.grey),
                  ),
                  Text(
                    convertDateTime(widget.model.createdTime),
                    style: pregular.copyWith(
                      fontSize: 20,
                      color:
                          Theme.of(context).appBarTheme.titleTextStyle?.color,
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
                    style: pmedium.copyWith(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.model.note,
                      style: pregular.copyWith(
                        fontSize: 20,
                        color:
                            Theme.of(context).appBarTheme.titleTextStyle?.color,
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
                    style: pmedium.copyWith(fontSize: 20, color: Colors.grey),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.model.photo ?? "",
                      style: pregular.copyWith(
                        fontSize: 20,
                        color:
                        Theme.of(context).appBarTheme.titleTextStyle?.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const Spacer(),
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
                        // Navigator.pushReplacementNamed(context, '/add');
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
                        await cubit.deleteModel(widget.model.id ?? -1);
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
        ),
      ),
    );
  }

  String convertDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
