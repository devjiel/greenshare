part of 'carbon_reduction_bloc.dart';

abstract class CarbonReductionEvent extends Equatable {
  const CarbonReductionEvent();

  @override
  List<Object?> get props => [];
}

class LoadCarbonReductionEvent extends CarbonReductionEvent {}