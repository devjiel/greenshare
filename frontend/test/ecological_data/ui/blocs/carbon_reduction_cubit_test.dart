import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/ecological_data/ui/blocs/carbon_reduction_cubit.dart';

void main() {
  group('CarbonReductionCubit', () {
    late CarbonReductionCubit carbonReductionCubit;

    setUp(() {
      carbonReductionCubit = CarbonReductionCubit();
    });

    tearDown(() {
      carbonReductionCubit.close();
    });

    blocTest<CarbonReductionCubit, CarbonReductionState>(
      'emits [CarbonReductionStateLoading, CarbonReductionStateLoaded] when loadCarbonReduction is called',
      build: () => carbonReductionCubit,
      act: (cubit) => cubit.loadCarbonReduction(),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        CarbonReductionStateLoading(),
        isA<CarbonReductionStateLoaded>()
            .having((state) => state.carbonReduction.value, 'value', 0.7)
            .having((state) => state.carbonReduction.unit, 'unit', 'tons'),
      ],
    );

    blocTest<CarbonReductionCubit, CarbonReductionState>(
      'emits [CarbonReductionStateError] when showError is called',
      build: () => carbonReductionCubit,
      act: (cubit) => cubit.showError('An error occurred'),
      expect: () => [
        CarbonReductionStateError('An error occurred'),
      ],
    );
  });
}