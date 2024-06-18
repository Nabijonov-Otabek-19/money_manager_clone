import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_manager_clone/feature/data/models/my_model.dart';

import '../../../../data/datasources/my_storage.dart';
import '../../home/cubit/home_cubit.dart';

part 'detail_state.dart';

part 'detail_cubit.freezed.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit() : super(const DetailState());

  final ExpenseStorage storage = ExpenseStorage.instance;

  Future<void> deleteModel(int id) async {
    await storage.delete(id);
  }

  Future<void> getModel(int id) async {
    emit(state.copyWith(loadState: LoadState.loading));
    final model = await storage.readNote(id);
    emit(state.copyWith(model: model, loadState: LoadState.loaded));
  }
}
