import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/constants.dart';
import '../../../../data/datasources/my_storage.dart';
import '../../../../data/models/my_enums.dart';
import '../../../../data/models/my_model.dart';

part 'main_state.dart';

part 'main_cubit.freezed.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  final ExpenseStorage storage = ExpenseStorage.instance;

  void onTappedScreen(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  Future<void> initial() async {
    await refreshData(DateTime(DateTime.now().year, DateTime.now().month));
    await getAllTypeModels();
  }

  Future<void> refreshData(DateTime monthTime) async {
    emit(state.copyWith(loadState: LoadState.loading));

    final List<Future> futures = [
      storage.getDaysByMonth(monthTime),
      storage.getCurrentMonthExpenses(),
      storage.getCurrentMonthIncomes(),
    ];

    final List<dynamic> results = await Future.wait(futures);

    final List<DayModel> data = results[0];
    final expense = results[1];
    final income = results[2];

    emit(state.copyWith(
      dayModels: data,
      currentMonthExpense: expense,
      currentMonthIncome: income,
      currentMonthBalance: income - expense,
    ));

    emit(state.copyWith(loadState: LoadState.loaded));
  }

  Future<void> deleteModel(int id) async {
    await storage.deleteExpense(id);
  }

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
