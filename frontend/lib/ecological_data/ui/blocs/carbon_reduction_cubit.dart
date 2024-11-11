import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class CarbonReductionCubit extends Cubit<CarbonReductionState> {
  CarbonReductionCubit() : super(CarbonReductionStateInitial());

  void loadCarbonReduction() {
    emit(CarbonReductionStateLoading());
    // Simulate a delay for loading carbon reduction
    Future.delayed(const Duration(milliseconds: 500), () {
      // Simulate loaded carbon reduction
      emit(CarbonReductionStateLoaded(const CarbonReduction(value: 0.7, unit: 'tons')));
    });
  }

  void showError(String message) {
    emit(CarbonReductionStateError(message));
  }
}

abstract class CarbonReductionState extends Equatable {}

class CarbonReductionStateInitial extends CarbonReductionState {
  @override
  List<Object?> get props => [];
}

class CarbonReductionStateLoading extends CarbonReductionState {
  @override
  List<Object?> get props => [];
}

class CarbonReductionStateLoaded extends CarbonReductionState {
  final CarbonReduction carbonReduction;

  CarbonReductionStateLoaded(this.carbonReduction);

  @override
  List<Object?> get props => [carbonReduction];
}

class CarbonReductionStateError extends CarbonReductionState {
  final String message;

  CarbonReductionStateError(this.message);

  @override
  List<Object?> get props => [message];
}

class CarbonReduction extends Equatable {
  final double value;
  final String unit;

  const CarbonReduction({
    required this.value,
    required this.unit,
  });

  @override
  List<Object?> get props => [value, unit];
}
