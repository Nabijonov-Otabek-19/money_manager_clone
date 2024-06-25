import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_manager_clone/core/utils/constants.dart';
import 'package:money_manager_clone/feature/data/datasources/my_storage.dart';

import '../../../../data/models/my_enums.dart';
import '../../../../data/models/my_model.dart';

part 'chart_state.dart';

part 'chart_cubit.freezed.dart';

class ChartCubit extends Cubit<ChartState> {
  ChartCubit() : super(const ChartState());

  ExpenseStorage storage = ExpenseStorage.instance;

  void changeType(String type) {
    emit(state.copyWith(moneyType: type));
  }

  Future<void> getAllTypeModels() async {
    emit(state.copyWith(loadState: LoadState.loading));

    final models = await storage.getModelsByTitle(state.moneyType);

    List<ExpenseModel> list = [];
    int totalExpense = 0;

    for (final title in allTypeList) {
      int total = 0;
      String icon = "";
      String tt = "";
      for (final model in models) {
        if (title == model.title) {
          total += model.number;
          tt = title;
          icon = model.icon;
        }
      }
      if (total != 0) {
        totalExpense += total;
        list.add(ExpenseModel(
          title: tt,
          icon: icon,
          number: total,
          type: "",
          note: "",
          createdTime: DateTime.now(),
          photo: "",
        ));
      }
    }

    list.sort((a, b) => b.number.compareTo(a.number));

    emit(state.copyWith(
      list: list,
      totalExpense: totalExpense,
      loadState: LoadState.loaded,
    ));
  }
}
