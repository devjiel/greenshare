import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:greenshare/common/config/injectable.dart';
import 'package:greenshare/ecological_data/ui/blocs/carbon_reduction_bloc.dart';
import 'package:greenshare/ecological_data/ui/models/carbon_reduction_view_model.dart';
import 'package:greenshare/file_upload/ui/blocs/available_files_bloc.dart';
import 'package:greenshare/file_upload/ui/models/file_view_model.dart';
import 'package:greenshare/home/ui/home_page.dart';

import '../test_helpers.dart';

class MockAvailableFilesBloc extends MockBloc<AvailableFilesEvent, AvailableFilesState> implements AvailableFilesBloc {}

class MockCarbonReductionBloc extends MockBloc<CarbonReductionEvent, CarbonReductionState> implements CarbonReductionBloc {}

void main() {
  final availableFilesBloc = MockAvailableFilesBloc();
  final carbonReductionBloc = MockCarbonReductionBloc();

  setUpAll(() async {
    await loadAppFonts();

    whenListen(
      availableFilesBloc,
      Stream.fromIterable([
        AvailableFilesLoaded([
          FileViewModel(name: 'file1.pdf', size: 1.2, expirationDate: DateTime(2024, 11, 11)),
          FileViewModel(name: 'file2.pdf', size: 2.5, expirationDate: DateTime(2024, 11, 11)),
          FileViewModel(name: 'file3.pdf', size: 3.7, expirationDate: DateTime(2024, 11, 11)),
        ]),
      ]),
      initialState: AvailableFilesInitial(),
    );

    whenListen(
      carbonReductionBloc,
      Stream.fromIterable([
        CarbonReductionStateLoaded(const CarbonReductionViewModel(value: 0.7, unit: 'tons')),
      ]),
      initialState: CarbonReductionStateLoading(),
    );

    getIt.registerLazySingleton<AvailableFilesBloc>(() => availableFilesBloc);
    getIt.registerLazySingleton<CarbonReductionBloc>(() => carbonReductionBloc);
  });

  group("HomePage page goldens", () {
    for (var locale in locales) {
      testGoldens("Desktop HomePage page in $locale", (WidgetTester tester) async {
        await tester.pumpWidgetInDesktopMode(
          widget: const HomePage(),
          locale: locale,
        );
        await tester.pump();
        await screenMatchesGolden(tester, 'desktop_home_page_$locale');
      });
    }
  });
}