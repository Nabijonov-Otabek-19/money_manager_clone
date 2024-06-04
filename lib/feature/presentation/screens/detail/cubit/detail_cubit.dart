import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/my_storage.dart';

part 'detail_state.dart';

part 'detail_cubit.freezed.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit() : super(const DetailState());

  final ExpenseStorage storage = ExpenseStorage.instance;

  Future<void> deleteModel(int id) async {
    await storage.delete(id);
  }
}
