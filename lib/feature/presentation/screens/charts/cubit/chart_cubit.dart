import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_manager_clone/feature/data/datasources/my_storage.dart';

part 'chart_state.dart';

part 'chart_cubit.freezed.dart';

class ChartCubit extends Cubit<ChartState> {
  ChartCubit() : super(const ChartState());

  ExpenseStorage storage = ExpenseStorage.instance;
}
