import 'package:equatable/equatable.dart';

class CarbonReductionViewModel extends Equatable {
  final double value;
  final String unit;

  const CarbonReductionViewModel({
    required this.value,
    required this.unit,
  });

  @override
  List<Object?> get props => [value, unit];
}