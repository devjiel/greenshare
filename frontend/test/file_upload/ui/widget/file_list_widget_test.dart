import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:greenshare/file_upload/ui/blocs/available_files/available_files_bloc.dart';
import 'package:greenshare/file_upload/ui/widgets/file_list_widget.dart';
import 'package:greenshare/user/ui/models/available_file_view_model.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helpers.dart';

class MockAvailableFilesBloc extends MockBloc<AvailableFilesEvent, AvailableFilesState> implements AvailableFilesBloc {}

void main() {
  final availableFilesBloc = MockAvailableFilesBloc();

  setUpAll(() async {
    await loadAppFonts();
  });

  group("FileListWidget goldens", () {
    testGoldens("Desktop FileList widget - valid case", (WidgetTester tester) async {
      when(() => availableFilesBloc.state).thenReturn(AvailableFilesLoaded([
        AvailableFileViewModel(name: 'file1.pdf', size: 1.2, expirationDate: DateTime(2024, 11, 11)),
        AvailableFileViewModel(name: 'file2.pdf', size: 2.5, expirationDate: DateTime(2024, 11, 11)),
        AvailableFileViewModel(name: 'file3.pdf', size: 3.7, expirationDate: DateTime(2024, 11, 11)),
      ]));

      await tester.pumpWidgetInPhoneMode(
        widget: BlocProvider<AvailableFilesBloc>.value(
          value: availableFilesBloc,
          child: const FileListWidget(),
        ),
      );
      await tester.pump();
      await screenMatchesGolden(tester, 'desktop_file_list_valid_widget');
    });

    testGoldens("Desktop FileList widget - valid case - no file available", (WidgetTester tester) async {
      when(() => availableFilesBloc.state).thenReturn(AvailableFilesLoaded(const []));

      await tester.pumpWidgetInPhoneMode(
        widget: BlocProvider<AvailableFilesBloc>.value(
          value: availableFilesBloc,
          child: const FileListWidget(),
        ),
      );
      await tester.pump();
      await screenMatchesGolden(tester, 'desktop_empty_file_list_valid_widget');
    });

    testGoldens("Desktop FileList widget - error case", (WidgetTester tester) async {
      when(() => availableFilesBloc.state).thenReturn(AvailableFilesError('An error occurred'));

      await tester.pumpWidgetInPhoneMode(
        widget: BlocProvider<AvailableFilesBloc>.value(
          value: availableFilesBloc,
          child: const FileListWidget(),
        ),
      );
      await tester.pump();
      await screenMatchesGolden(tester, 'desktop_file_list_error_widget');
    });
  });
}