part of 'carbon_reduction_bloc.dart';

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
  final CarbonReductionViewModel carbonReduction;

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