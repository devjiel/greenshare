import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:greenshare/files/ui/blocs/available_files/available_files_cubit.dart';
import 'package:greenshare/files/ui/models/file_view_model.dart';
import 'package:greenshare/files/ui/widgets/file_list_widget.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helpers.dart';

class MockAvailableFilesCubit extends MockCubit<AvailableFilesState> implements AvailableFilesCubit {}

void main() {
  final availableFilesCubit = MockAvailableFilesCubit();

  setUpAll(() async {
    await loadAppFonts();
  });

  group("FileListWidget goldens", () {
    testGoldens("Desktop FileList widget - valid case", (WidgetTester tester) async {
      when(() => availableFilesCubit.state).thenReturn(AvailableFilesLoaded([
        FileViewModel(name: 'file1.pdf', size: 1.2, expirationDate: DateTime(2024, 11, 11), downloadUrl: 'http://example.com/file1.pdf', ownerUid: 'ownerUid#1'),
        FileViewModel(name: 'file2.pdf', size: 2.5, expirationDate: DateTime(2024, 11, 11), downloadUrl: 'http://example.com/file2.pdf', ownerUid: 'ownerUid#2'),
        FileViewModel(name: 'file3.pdf', size: 3.7, expirationDate: DateTime(2024, 11, 11), downloadUrl: 'http://example.com/file3.pdf', ownerUid: 'ownerUid#3'),
      ]));

      await tester.pumpWidgetInPhoneMode(
        widget: BlocProvider<AvailableFilesCubit>.value(
          value: availableFilesCubit,
          child: const FileListWidget(),
        ),
      );
      await tester.pump();
      await screenMatchesGolden(tester, 'desktop_file_list_valid_widget');
    });

    testGoldens("Desktop FileList widget - valid case - no file available", (WidgetTester tester) async {
      when(() => availableFilesCubit.state).thenReturn(AvailableFilesLoaded(const []));

      await tester.pumpWidgetInPhoneMode(
        widget: BlocProvider<AvailableFilesCubit>.value(
          value: availableFilesCubit,
          child: const FileListWidget(),
        ),
      );
      await tester.pump();
      await screenMatchesGolden(tester, 'desktop_empty_file_list_valid_widget');
    });

    testGoldens("Desktop FileList widget - error case", (WidgetTester tester) async {
      when(() => availableFilesCubit.state).thenReturn(AvailableFilesError('An error occurred'));

      await tester.pumpWidgetInPhoneMode(
        widget: BlocProvider<AvailableFilesCubit>.value(
          value: availableFilesCubit,
          child: const FileListWidget(),
        ),
      );
      await tester.pump();
      await screenMatchesGolden(tester, 'desktop_file_list_error_widget');
    });
  });
}