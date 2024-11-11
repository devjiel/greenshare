import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:greenshare/ecological_data/ui/blocs/carbon_reduction_cubit.dart';
import 'package:greenshare/ecological_data/ui/widgets/carbon_footprint_reduction_widget.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helpers.dart';

class MockCarbonReductionCubit extends MockBloc<CarbonReductionCubit, CarbonReductionState> implements CarbonReductionCubit {}

void main() {
  final carbonReductionCubit = MockCarbonReductionCubit();

  setUpAll(() async {
    await loadAppFonts();
  });

  group("CarbonFootprintReductionWidget goldens", () {
    testGoldens("Desktop CarbonFootprintReduction widget - valid case", (WidgetTester tester) async {
      when(() => carbonReductionCubit.state).thenReturn(CarbonReductionStateLoaded(const CarbonReduction(value: 0.7, unit: 'tons')));

      await tester.pumpWidgetInPhoneMode(
        widget: BlocProvider<CarbonReductionCubit>.value(
          value: carbonReductionCubit,
          child: const CarbonFootprintReductionWidget(),
        ),
      );
      await tester.pump();
      await screenMatchesGolden(tester, 'desktop_carbon_footprint_reduction_valid_widget');
    });

    testGoldens("Desktop CarbonFootprintReduction widget - error case", (WidgetTester tester) async {
      when(() => carbonReductionCubit.state).thenReturn(CarbonReductionStateError('An error occurred'));

      await tester.pumpWidgetInPhoneMode(
        widget: BlocProvider<CarbonReductionCubit>.value(
          value: carbonReductionCubit,
          child: const CarbonFootprintReductionWidget(),
        ),
      );
      await tester.pump();
      await screenMatchesGolden(tester, 'desktop_carbon_footprint_reduction_error_widget');
    });
  });
}
