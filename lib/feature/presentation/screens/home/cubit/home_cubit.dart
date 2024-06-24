import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/my_storage.dart';
import '../../../../data/models/my_model.dart';

part 'home_state.dart';

part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  final ExpenseStorage storage = ExpenseStorage.instance;

  Future<void> refreshData() async {
    emit(state.copyWith(loadState: LoadState.loading));

    final List<Future> futures = [
      storage.getAllExpenses(),
      storage.getCurrentMonthExpenses(),
      storage.getCurrentMonthIncomes(),
    ];

    final List<dynamic> results = await Future.wait(futures);

    final List<MonthModel> data = results[0];
    final expense = results[1];
    final income = results[2];

    emit(state.copyWith(
      currentMonthExpense: expense,
      currentMonthIncome: income,
      currentMonthBalance: income - expense,
      list: data,
    ));

    emit(state.copyWith(loadState: LoadState.loaded));
  }

  Future<void> deleteModel(int id) async {
    await storage.deleteExpense(id);
  }
}
