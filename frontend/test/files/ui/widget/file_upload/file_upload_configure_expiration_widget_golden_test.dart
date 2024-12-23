import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:greenshare/files/ui/blocs/available_files/available_files_cubit.dart';
import 'package:greenshare/files/ui/blocs/file_upload/expiration_configuration/expiration_configuration_cubit.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_configure_expiration_widget.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_helpers.dart';

class MockFileUploadBloc extends MockBloc<FileUploadEvent, FileUploadState> implements FileUploadBloc {}

class MockConfigurationCubit extends MockCubit<ExpirationConfigurationState> implements ExpirationConfigurationCubit {}

class MockAvailableFilesCubit extends MockCubit<AvailableFilesState> implements AvailableFilesCubit {}

void main() {
  final fileUploadBloc = MockFileUploadBloc();
  final configurationCubit = MockConfigurationCubit();
  final availableFilesCubit = MockAvailableFilesCubit();

  setUpAll(() async {
    await loadAppFonts();
  });

  group("FileUploadConfigureExpirationWidget goldens", () {
    testGoldens("Desktop FileUploadConfigureExpiration widget - delay selected", (WidgetTester tester) async {
      when(() => fileUploadBloc.state)
          .thenReturn(const FileRegistered('document.doc', 1024, 'https://example.com/document.doc', 'path/to/document.doc', 'fileUid'));
      when(() => configurationCubit.state).thenReturn(const ExpirationConfigurationState(expirationType: FileExpirationType.delay));
      when(() => availableFilesCubit.updateExpirationDate(any(), any())).thenAnswer((_) => Future.value());

      await tester.pumpWidgetInDesktopMode(
        widget: MultiBlocProvider(
          providers: [
            BlocProvider<FileUploadBloc>.value(
              value: fileUploadBloc,
            ),
            BlocProvider<ExpirationConfigurationCubit>.value(
              value: configurationCubit,
            ),
            BlocProvider<AvailableFilesCubit>.value(
              value: availableFilesCubit,
            ),
          ],
          child: const FileUploadConfigureExpirationWidget(),
        ),
      );
      await tester.pump();
      await screenMatchesGolden(tester, 'desktop_file_upload_configure_expiration_delay_widget');
    });

    testGoldens("Desktop FileUploadConfigureExpiration widget - delete at download", (WidgetTester tester) async {
      when(() => fileUploadBloc.state)
          .thenReturn(const FileRegistered('document.doc', 1024, 'https://example.com/document.doc', 'path/to/document.doc', 'fileUid'));
      when(() => configurationCubit.state).thenReturn(const ExpirationConfigurationState(expirationType: FileExpirationType.atDownload));
      when(() => availableFilesCubit.updateExpirationDate(any(), any())).thenAnswer((_) => Future.value());

      await tester.pumpWidgetInDesktopMode(
        widget: MultiBlocProvider(
          providers: [
            BlocProvider<FileUploadBloc>.value(
              value: fileUploadBloc,
            ),
            BlocProvider<ExpirationConfigurationCubit>.value(
              value: configurationCubit,
            ),
            BlocProvider<AvailableFilesCubit>.value(
              value: availableFilesCubit,
            ),
          ],
          child: const FileUploadConfigureExpirationWidget(),
        ),
      );
      await tester.pump();
      await screenMatchesGolden(tester, 'desktop_file_upload_configure_expiration_delete_at_download_widget');
    });
  });
}
