import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/my_storage.dart';
import '../../../../data/models/my_model.dart';

part 'add_edit_state.dart';

part 'add_cubit.freezed.dart';

class AddEditCubit extends Cubit<AddEditState> {
  AddEditCubit() : super(const AddEditState());

  final ExpenseStorage storage = ExpenseStorage.instance;

  Future<void> addExpense(ExpenseModel model) async {
    await storage.addExpense(model);
  }

  Future<void> updateExpense(ExpenseModel model) async {
    await storage.updateExpense(model);
  }
}
