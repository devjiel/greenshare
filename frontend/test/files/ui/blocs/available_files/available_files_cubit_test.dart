import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/files/repositories/files_repository.dart';
import 'package:greenshare/files/repositories/models/file_entity_model.dart';
import 'package:greenshare/files/ui/blocs/available_files/available_files_cubit.dart';
import 'package:greenshare/files/ui/models/file_view_model.dart';
import 'package:greenshare/user/ui/models/user_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockFilesRepository extends Mock implements FilesRepository {}

void main() {
  group('AvailableFilesCubit', () {
    late AvailableFilesCubit availableFilesCubit;
    final filesRepository = MockFilesRepository();

    setUpAll(() {
      availableFilesCubit = AvailableFilesCubit(filesRepository);
      registerFallbackValue(const FileEntityModel(uid: '', name: '', size: 0.0, expirationDate: null, downloadUrl: '', ownerUid: ''));
    });

    tearDown(() {
      availableFilesCubit.close();
    });

    blocTest<AvailableFilesCubit, AvailableFilesState>(
      'emits [AvailableFilesLoading, AvailableFilesLoaded] when loadFiles is called',
      build: () {
        when(() => filesRepository.getFiles(['uid1', 'uid2', 'uid3'])).thenAnswer(
          (_) => Future.value([
            FileEntityModel(
                uid: 'uid1', name: 'file1.pdf', size: 1.2, expirationDate: DateTime(2024, 11, 12), downloadUrl: 'url1', ownerUid: 'ownerUid#1'),
            FileEntityModel(
                uid: 'uid2', name: 'file2.pdf', size: 2.5, expirationDate: DateTime(2024, 11, 11), downloadUrl: 'url2', ownerUid: 'ownerUid#2'),
            FileEntityModel(
                uid: 'uid3', name: 'file3.pdf', size: 3.7, expirationDate: DateTime(2024, 11, 13), downloadUrl: 'url3', ownerUid: 'ownerUid#3'),
          ]),
        );
        return availableFilesCubit;
      },
      act: (bloc) => bloc.loadUserFiles(const UserViewModel(uid: 'ownerUid#1', files: ['uid1', 'uid2', 'uid3'])),
      wait: const Duration(seconds: 3),
      expect: () => [
        isA<AvailableFilesLoaded>()
            .having((state) => state.files.length, 'files length', 3)
            .having((state) => state.files[0].name, 'file 1 name', 'file3.pdf')
            .having((state) => state.files[0].size, 'file 1 size', 3.7)
            .having((state) => state.files[0].expirationDate, 'file 1 expiration date', DateTime(2024, 11, 13))
            .having((state) => state.files[0].downloadUrl, 'file 1 download url', 'url3')
            .having((state) => state.files[0].ownerUid, 'file 1 owner uid', 'ownerUid#3')
            .having((state) => state.files[0].isOwnedByCurrentUser, 'file 1 is not owned by user', false)
            .having((state) => state.files[1].name, 'file 2 name', 'file1.pdf')
            .having((state) => state.files[1].size, 'file 2size', 1.2)
            .having((state) => state.files[1].expirationDate, 'file 2 expiration date', DateTime(2024, 11, 12))
            .having((state) => state.files[1].downloadUrl, 'file 2 download url', 'url1')
            .having((state) => state.files[1].ownerUid, 'file 2 owner uid', 'ownerUid#1')
            .having((state) => state.files[1].isOwnedByCurrentUser, 'file 2 is owned by user', true)
            .having((state) => state.files[2].name, 'file 3 name', 'file2.pdf')
            .having((state) => state.files[2].size, 'file 3 size', 2.5)
            .having((state) => state.files[2].expirationDate, 'file 3 expiration date', DateTime(2024, 11, 11))
            .having((state) => state.files[2].downloadUrl, 'file 3 download url', 'url2')
            .having((state) => state.files[2].ownerUid, 'file 3 owner uid', 'ownerUid#2')
            .having((state) => state.files[2].isOwnedByCurrentUser, 'file 3 is not owned by user', false),
      ],
    );

    test('should get file uid when addAvailableFile is called', () async {
      when(() => filesRepository.saveFile(any())).thenAnswer(
        (_) => Future.value('uid4'),
      );

      final result = await availableFilesCubit.addAvailableFile(FileViewModel(
        uid: 'uid4',
        name: 'file4.pdf',
        size: 4.0,
        expirationDate: DateTime(2024, 11, 14),
        downloadUrl: 'url4',
        ownerUid: 'ownerUid#4',
        isOwnedByCurrentUser: true,
      ));

      expect(result, 'uid4');

      verify(() => filesRepository.saveFile(any())).called(1);
    });

    test('should success when deleteAvailableFile is called', () async {
      when(() => filesRepository.deleteFile(any())).thenAnswer(
        (_) => Future.value(),
      );

      await availableFilesCubit.deleteAvailableFile(FileViewModel(
        uid: 'uid4',
        name: 'file4.pdf',
        size: 4.0,
        expirationDate: DateTime(2024, 11, 14),
        downloadUrl: 'url4',
        ownerUid: 'ownerUid#4',
        isOwnedByCurrentUser: true,
      ));

      verify(() => filesRepository.deleteFile('uid4')).called(1);

    });
  });
}
