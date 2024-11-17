import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/files/repositories/files_repository.dart';
import 'package:greenshare/files/repositories/models/file_entity_model.dart';

void main() {
  FirebaseDatabase firebaseDatabase = MockFirebaseDatabase.instance;
  const fakeData = {
    'files': {
      'file1': {
        'uid': 'file1',
        'name': 'file1',
        'size': 1.2,
        'expirationDate': '2024-11-12',
        'downloadUrl': 'url',
      },
      'file2': {
        'uid': 'file2',
        'name': 'file2',
        'size': 2.5,
        'expirationDate': '2024-11-11',
        'downloadUrl': 'url',
      },
    }
  };

  late FirebaseFilesRepository repository;

  setUp(() {
    repository = FirebaseFilesRepository(firebaseDatabase);
  });

  group('FilesRepository', () {
    group('getFiles', () {
      MockFirebaseDatabase.instance.ref().set(fakeData);

      test('should return list of files when files exist', () async {
        final files = await repository.getFiles(['file1', 'file2']);

        expect(files, isA<List<FileEntityModel>>());
        expect(files.length, 2);
        expect(
            files[0],
            isA<FileEntityModel>()
                .having((file) => file.uid, 'file 1 uid', 'file1')
                .having((file) => file.name, 'file 1 name', 'file1')
                .having((file) => file.size, 'file 1 size', 1.2)
                .having((file) => file.expirationDate, 'file 1 expiration date', DateTime(2024, 11, 12))
                .having((file) => file.downloadUrl, 'file 1 download url', 'url'));
        expect(files[1],
            isA<FileEntityModel>()
                .having((file) => file.uid, 'file 2 uid', 'file2')
                .having((file) => file.name, 'file 2 name', 'file2')
                .having((file) => file.size, 'file 2 size', 2.5)
                .having((file) => file.expirationDate, 'file 2 expiration date', DateTime(2024, 11, 11))
                .having((file) => file.downloadUrl, 'file 2 download url', 'url'));
      });

      test('should return empty list when no files exist', () async {
        final files = await repository.getFiles(['file3']);

        expect(files, isA<List<FileEntityModel>>());
        expect(files.isEmpty, true);
      });
    });

    group('saveFile', () {
      MockFirebaseDatabase.instance.ref().set(fakeData);

      test('should save file successfully', () async {
        final file = FileEntityModel(uid: 'file2', name: 'file2', size: 1.2, expirationDate: DateTime(2024, 11, 12), downloadUrl: 'url');

        try {
          final uid = await repository.saveFile(file);
          expect(uid, 'file2');
        } catch (e) {
          fail('Error saving file: $e');
        }

        final savedFile = await firebaseDatabase.ref().child('files').child('file2').once();
        expect(savedFile.snapshot.value, isNotNull);
      });
    });
  });
}
