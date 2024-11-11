import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:greenshare/config/injectable.dart';
import 'package:greenshare/file_upload/ui/blocs/available_files_cubit.dart';
import 'package:greenshare/main.dart';

import '../test_helpers.dart';

class MockAvailableFilesCubit extends MockBloc<AvailableFilesCubit, AvailableFilesState> implements AvailableFilesCubit {}

void main() {
  final availableFilesCubit = MockAvailableFilesCubit();

  setUpAll(() async {
    await loadAppFonts();

    whenListen(
      availableFilesCubit,
      Stream.fromIterable([
        AvailableFilesLoaded([
          FileState(name: 'file1.pdf', size: 1.2, expirationDate: DateTime(2024, 11, 11)),
          FileState(name: 'file2.pdf', size: 2.5, expirationDate: DateTime(2024, 11, 11)),
          FileState(name: 'file3.pdf', size: 3.7, expirationDate: DateTime(2024, 11, 11)),
        ]),
      ]),
      initialState: AvailableFilesInitial(),
    );

    getIt.registerLazySingleton<AvailableFilesCubit>(() => availableFilesCubit);
  });

  group("HomePage page goldens", () {
    for (var locale in locales) {
      testGoldens("Desktop HomePage page in $locale", (WidgetTester tester) async {
        await tester.pumpWidgetInDesktopMode(
          const HomePage(),
          locale,
        );
        await tester.pump();
        await screenMatchesGolden(tester, 'desktop_home_page_$locale');
      });
    }
  });
}