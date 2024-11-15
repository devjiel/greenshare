import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/ecological_data/ui/blocs/carbon_reduction_bloc.dart';

void main() {
  group('CarbonReductionBloc', () {
    late CarbonReductionBloc carbonReductionBloc;

    setUp(() {
      carbonReductionBloc = CarbonReductionBloc();
    });

    tearDown(() {
      carbonReductionBloc.close();
    });

    blocTest<CarbonReductionBloc, CarbonReductionState>(
      'emits [CarbonReductionStateLoading, CarbonReductionStateLoaded] when loadCarbonReduction is called',
      build: () => carbonReductionBloc,
      act: (bloc) => bloc.add(LoadCarbonReductionEvent()),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        CarbonReductionStateLoading(),
        isA<CarbonReductionStateLoaded>()
            .having((state) => state.carbonReduction.value, 'value', 0.0)
            .having((state) => state.carbonReduction.unit, 'unit', 'tons'),
      ],
    );
  });
}