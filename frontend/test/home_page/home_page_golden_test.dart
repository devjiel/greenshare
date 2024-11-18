import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:greenshare/common/config/injectable.dart';
import 'package:greenshare/ecological_data/ui/blocs/carbon_reduction_bloc.dart';
import 'package:greenshare/ecological_data/ui/models/carbon_reduction_view_model.dart';
import 'package:greenshare/files/ui/blocs/available_files/available_files_cubit.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/files/ui/models/file_view_model.dart';
import 'package:greenshare/home/ui/home_page.dart';
import 'package:greenshare/share/ui/bloc/share_links/share_links_bloc.dart';
import 'package:greenshare/user/ui/blocs/user_bloc.dart';
import 'package:greenshare/user/ui/models/user_view_model.dart';
import 'package:mocktail/mocktail.dart';

import '../test_helpers.dart';

class MockAvailableFilesCubit extends MockCubit<AvailableFilesState> implements AvailableFilesCubit {}

class MockCarbonReductionBloc extends MockBloc<CarbonReductionEvent, CarbonReductionState> implements CarbonReductionBloc {}

class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}

class MockFileUploadBloc extends MockBloc<FileUploadEvent, FileUploadState> implements FileUploadBloc {}

class MockShareLinksBloc extends MockBloc<ShareLinksEvent, ShareLinksState> implements ShareLinksBloc {}

void main() {
  final availableFilesCubit = MockAvailableFilesCubit();
  final carbonReductionBloc = MockCarbonReductionBloc();
  final fileUploadBloc = MockFileUploadBloc();
  final userBloc = MockUserBloc();
  final shareLinksBloc = MockShareLinksBloc();

  setUpAll(() async {
    await loadAppFonts();

    whenListen(
      availableFilesCubit,
      Stream.fromIterable([
        AvailableFilesLoaded([
          FileViewModel(name: 'file1.pdf', size: 1.2, expirationDate: DateTime(2024, 11, 11), downloadUrl: 'http://example.com/file1.pdf'),
          FileViewModel(name: 'file2.pdf', size: 2.5, expirationDate: DateTime(2024, 11, 11), downloadUrl: 'http://example.com/file2.pdf'),
          FileViewModel(name: 'file3.pdf', size: 3.7, expirationDate: DateTime(2024, 11, 11), downloadUrl: 'http://example.com/file3.pdf'),
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
    when(() => userBloc.state).thenReturn(const UserStateLoaded(UserViewModel(uid: 'test-uid')));

    whenListen(fileUploadBloc, Stream.fromIterable([const FileUploadInitial()]), initialState: const FileUploadInitial());

    when(() => shareLinksBloc.state).thenReturn(const ShareLinksInitial());

    getIt.registerLazySingleton<UserBloc>(() => userBloc);
    getIt.registerLazySingleton<FileUploadBloc>(() => fileUploadBloc);
    getIt.registerLazySingleton<AvailableFilesCubit>(() => availableFilesCubit);
    getIt.registerLazySingleton<CarbonReductionBloc>(() => carbonReductionBloc);
    getIt.registerLazySingleton<ShareLinksBloc>(() => shareLinksBloc);
  });

  group("HomePage page goldens", () {
    for (var locale in locales) {
      testGoldens("Desktop HomePage page in $locale", (WidgetTester tester) async {
        await tester.pumpWidgetInDesktopMode(
          widget: MultiBlocProvider(
            providers: [
              BlocProvider<UserBloc>.value(
                value: userBloc,
              ),
              BlocProvider<CarbonReductionBloc>.value(
                value: carbonReductionBloc,
              ),
            ],
            child: const HomePage(),
          ),
          locale: locale,
        );
        await tester.pump();
        await screenMatchesGolden(tester, 'desktop_home_page_$locale');
      });
    }
  });
}
