import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:greenshare/common/ui/widgets/card.dart';
import 'package:greenshare/files/ui/blocs/available_files/available_files_cubit.dart';
import 'package:greenshare/files/ui/blocs/file_upload/expiration_configuration/expiration_configuration_cubit.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/files/ui/models/file_view_model.dart';
import 'package:greenshare/files/ui/widgets/file_list/file_list_widget.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_configure_share_widget.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_in_progress_widget.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_configure_expiration_widget.dart';
import 'package:greenshare/share/ui/bloc/share_links/share_links_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_helpers.dart';

class MockFileUploadBloc extends MockBloc<FileUploadEvent, FileUploadState> implements FileUploadBloc {}

class MockShareLinksBloc extends MockBloc<ShareLinksEvent, ShareLinksState> implements ShareLinksBloc {}

void main() {
  final fileUploadBloc = MockFileUploadBloc();
  final shareLinksBloc = MockShareLinksBloc();

  setUpAll(() async {
    await loadAppFonts();
  });

  group("FileUploadConfigureShareWidget goldens", () {
    testGoldens("Desktop FileUploadConfigureShare widget - share link initial", (WidgetTester tester) async {
      when(() => fileUploadBloc.state)
          .thenReturn(FileUploadedWithExpiration('document.doc', 1024, 'https://example.com/document.doc', 'path/to/document.doc', 'fileUid', DateTime(2024, 11, 19)));

      when(() => shareLinksBloc.state).thenReturn(const ShareLinksInitial());

      await tester.pumpWidgetInDesktopMode(
        widget: MultiBlocProvider(
          providers: [
            BlocProvider<FileUploadBloc>.value(
              value: fileUploadBloc,
            ),
            BlocProvider<ShareLinksBloc>.value(
              value: shareLinksBloc,
            ),
          ],
          child: const FileUploadConfigureShareWidget(),
        ),
      );
      await tester.pump();
      await screenMatchesGolden(tester, 'desktop_file_upload_configure_share_link_initial_widget');
    });
    
    testGoldens("Desktop FileUploadConfigureShare widget - share link created", (WidgetTester tester) async {
      when(() => fileUploadBloc.state)
          .thenReturn(FileUploadedWithExpiration('document.doc', 1024, 'https://example.com/document.doc', 'path/to/document.doc', 'fileUid', DateTime(2024, 11, 19)));

      when(() => shareLinksBloc.state).thenReturn(const ShareLinkCreated('linkUid'));

      await tester.pumpWidgetInDesktopMode(
        widget: MultiBlocProvider(
          providers: [
            BlocProvider<FileUploadBloc>.value(
              value: fileUploadBloc,
            ),
            BlocProvider<ShareLinksBloc>.value(
              value: shareLinksBloc,
            ),
          ],
          child: const FileUploadConfigureShareWidget(),
        ),
      );
      await tester.pump();
      await screenMatchesGolden(tester, 'desktop_file_upload_configure_share_link_created_widget');
    });
  });
}
