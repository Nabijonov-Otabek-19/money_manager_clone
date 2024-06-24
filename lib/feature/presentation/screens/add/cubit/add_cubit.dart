import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/my_storage.dart';
import '../../../../data/models/my_model.dart';

part 'add_state.dart';

part 'add_cubit.freezed.dart';

class AddCubit extends Cubit<AddState> {
  AddCubit() : super(const AddState());

  final ExpenseStorage storage = ExpenseStorage.instance;

  Future<void> addData(ExpenseModel model) async {
    await storage.addExpense(model);
  }

  Future<void> editModel(ExpenseModel model) async {
    await storage.updateExpense(model);
  }
}
