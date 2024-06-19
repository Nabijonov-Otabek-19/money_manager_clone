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

    final List<ExpenseModel> data = await storage.readAllNotes();
    final expense = await storage.getExpense();
    final income = await storage.getIncome();

    emit(state.copyWith(
      expense: expense,
      income: income,
      balance: income - expense,
      list: data,
    ));

    emit(state.copyWith(loadState: LoadState.loaded));
  }

  Future<void> deleteModel(int id) async {
    await storage.delete(id);
  }
}
