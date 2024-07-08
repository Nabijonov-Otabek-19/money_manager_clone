import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_manager_clone/feature/data/models/my_model.dart';

import '../../../../data/datasources/my_storage.dart';
import '../../../../data/models/my_enums.dart';

part 'detail_state.dart';

part 'detail_cubit.freezed.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit() : super(const DetailState());

  final ExpenseStorage storage = ExpenseStorage.instance;

  Future<void> deleteModel(int id) async {
    await storage.deleteExpense(id);
  }

  Future<void> getModelById(int id) async {
    emit(state.copyWith(loadState: LoadState.loading));

    final model = await storage.getExpenseById(id);

    emit(state.copyWith(model: model, loadState: LoadState.loaded));
  }
}
