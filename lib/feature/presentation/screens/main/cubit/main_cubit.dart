import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/constants.dart';
import '../../../../data/datasources/my_storage.dart';
import '../../../../data/models/my_enums.dart';
import '../../../../data/models/my_model.dart';

part 'main_state.dart';

part 'main_cubit.freezed.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainState());

  final ExpenseStorage storage = ExpenseStorage.instance;

  void onTappedScreen(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void changeDateTime(DateTime monthTime) {
    emit(state.copyWith(
      selectedTime: DateTime(monthTime.year, monthTime.month, monthTime.day),
    ));
  }

  Future<void> refreshData() async {
    emit(state.copyWith(loadState: LoadState.loading));

    final dateTime = DateTime(DateTime.now().year, DateTime.now().month);

    final List<Future> futures = [
      storage.getDaysByMonth(state.selectedTime ?? dateTime),
      storage.getCurrentMonthExpenses(state.selectedTime ?? dateTime),
      storage.getCurrentMonthIncomes(state.selectedTime ?? dateTime),
      storage.getModelsByType(state.moneyType, state.selectedTime ?? dateTime),
    ];

    final List<dynamic> results = await Future.wait(futures);

    final List<DayModel> data = results[0];
    final int expense = results[1];
    final int income = results[2];
    final List<ExpenseModel> modelsByTitle = results[3];

    List<ExpenseModel> list = [];
    int totalExpense = 0;

    for (final title in allTypeList) {
      int total = 0;
      String icon = "";
      String tt = "";
      for (final model in modelsByTitle) {
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
          createdTime: state.selectedTime ??
              DateTime(DateTime.now().year, DateTime.now().month),
          photo: "",
        ));
      }
    }

    list.sort((a, b) => b.number.compareTo(a.number));

    emit(state.copyWith(
      dayModels: data,
      currentMonthExpense: expense,
      currentMonthIncome: income,
      currentMonthBalance: income - expense,
      totalExpense: totalExpense,
      list: list,
    ));

    emit(state.copyWith(loadState: LoadState.loaded));
  }

  Future<void> getAllTypeModels() async {
    emit(state.copyWith(loadState: LoadState.loading));

    final models = await storage.getModelsByType(
      state.moneyType,
      state.selectedTime ?? DateTime(DateTime.now().year, DateTime.now().month),
    );

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
          createdTime: state.selectedTime ??
              DateTime(DateTime.now().year, DateTime.now().month),
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

  Future<void> deleteModel(int id) async {
    await storage.deleteExpense(id);
  }

  void changeType(String type) {
    emit(state.copyWith(moneyType: type));
  }
}
