import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'models/carbon_reduction_view_model.dart';
part 'carbon_reduction_event.dart';
part 'carbon_reduction_state.dart';

@singleton
class CarbonReductionBloc extends Bloc<CarbonReductionEvent, CarbonReductionState> {

  CarbonReductionBloc() : super(CarbonReductionStateInitial()) {
    on<LoadCarbonReductionEvent>((event, emit) => _loadCarbonReduction(emit));
  }

  void _loadCarbonReduction(Emitter<CarbonReductionState> emit) async {
    emit(CarbonReductionStateLoading());
    await Future.delayed(const Duration(milliseconds: 500), () {
      emit(CarbonReductionStateLoaded(const CarbonReductionViewModel(value: 0.7, unit: 'tons')));
    });
  }
}
