import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_manager_clone/feature/data/datasources/my_storage.dart';
import 'package:money_manager_clone/feature/data/models/my_enums.dart';

import '../../../../data/models/my_model.dart';

part 'search_state.dart';

part 'search_cubit.freezed.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState());

  final ExpenseStorage _storage = ExpenseStorage.instance;

  Future<void> searchBy(String note, String type) async {
    emit(state.copyWith(loadState: LoadState.loading));

    final List<ExpenseModel> list = await _storage.searchByNote(note, type);

    emit(state.copyWith(list: list, loadState: LoadState.loaded));
  }
}
