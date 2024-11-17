import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/files/repositories/models/storage_repository_error.dart';
import 'package:greenshare/files/repositories/storage_repository.dart';
import 'package:mocktail/mocktail.dart';

class CustomMockFirebaseStorage extends Mock implements FirebaseStorage {}

main() {
  group('StorageRepository', () {
    late StorageRepository storageRepository;
    final storage = MockFirebaseStorage(); // TODO: this lib need more tweak to return error case

    test('uploadFile should return a Ok with UploadTaskMock', () async {
      storageRepository = FirebaseStorageRepository(storage);

      final result = storageRepository.uploadFile('path', 'file1.pdf', Uint8List(1));

      expect(result.isRight, true);
      expect(result.right, isA<UploadTask>());

    });

    test('uploadFile should return a Left with StorageRepositoryError', () async {
      final firebaseStorage = CustomMockFirebaseStorage();
      storageRepository = FirebaseStorageRepository(firebaseStorage);

      when(() => firebaseStorage.ref()).thenThrow(Exception('Error'));

      final result = storageRepository.uploadFile('path', 'file1.pdf', Uint8List(1));

      expect(result.isLeft, true);
      expect(result.left, isA<StorageRepositoryError>());

    });
  });
}