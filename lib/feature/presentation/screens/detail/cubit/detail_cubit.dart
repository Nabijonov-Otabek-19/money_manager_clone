import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_manager_clone/feature/data/models/my_model.dart';

import '../../../../data/datasources/my_storage.dart';

part 'detail_state.dart';

part 'detail_cubit.freezed.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit() : super(const DetailState());

  final ExpenseStorage storage = ExpenseStorage.instance;

  Future<void> editModel(ExpenseModel model) async {
    final int numberOfChanges = await storage.update(model);
    debugPrint("EDITED : $numberOfChanges");
  }

  Future<void> deleteModel(int id) async {
    final int numberOfRowsAffected = await storage.delete(id);
    debugPrint("DELETED : $numberOfRowsAffected");
  }
}
