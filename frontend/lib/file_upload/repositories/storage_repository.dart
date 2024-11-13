import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:greenshare/file_upload/repositories/models/storage_repository_error.dart';
import 'package:injectable/injectable.dart';

abstract class StorageRepository {
  Either<StorageRepositoryError, UploadTask> uploadFile(String path, String fileName, Uint8List bytes);
}

@LazySingleton(as: StorageRepository)
class FirebaseStorageRepository implements StorageRepository {
  final FirebaseStorage _storage;

  FirebaseStorageRepository(this._storage);

  @override
  Either<StorageRepositoryError, UploadTask> uploadFile(String path, String fileName, Uint8List bytes) {
    try {
      final ref = _storage.ref().child(path).child(fileName);
      final uploadTask = ref.putData(bytes);

      return Right<StorageRepositoryError, UploadTask>(uploadTask);
    } catch (e) {
      return Left<StorageRepositoryError, UploadTask>(StorageRepositoryError.technicalError("Error uploading file: $e"));
    }
  }
}
