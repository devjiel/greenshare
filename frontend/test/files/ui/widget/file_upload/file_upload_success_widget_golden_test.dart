import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:greenshare/files/ui/blocs/available_files/available_files_cubit.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/files/ui/models/file_view_model.dart';
import 'package:greenshare/files/ui/widgets/file_list/file_list_widget.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_in_progress_widget.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_success_widget.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_helpers.dart';

class MockFileUploadBloc extends MockBloc<FileUploadEvent, FileUploadState> implements FileUploadBloc {}

void main() {
  final fileUploadBloc = MockFileUploadBloc();

  setUpAll(() async {
    await loadAppFonts();
  });

  group("FileUploadSuccessWidget goldens", () {
    testGoldens("Desktop FileUploadSuccess widget", (WidgetTester tester) async {
      when(() => fileUploadBloc.state).thenReturn(const FileUploadSuccess('document.doc', 1024, 'https://example.com/document.doc', 'path/to/document.doc'));

      await tester.pumpWidgetInDesktopMode(
        widget: BlocProvider<FileUploadBloc>.value(
          value: fileUploadBloc,
          child: const FileUploadSuccessWidget(),
        ),
      );
      await tester.pump();
      await screenMatchesGolden(tester, 'desktop_file_upload_success_widget');
    });
  });
}