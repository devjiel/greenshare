import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:greenshare/files/repositories/models/storage_repository_error.dart';
import 'package:injectable/injectable.dart';

abstract class StorageRepository {
  // TODO UploadTask should be abstracted
  Either<StorageRepositoryError, UploadTask> uploadFile(String path, String fileName, Uint8List bytes);

  Future<void> removeFile(String path);
}

@LazySingleton(as: StorageRepository)
class FirebaseStorageRepository implements StorageRepository {
  final FirebaseStorage _storage;

  FirebaseStorageRepository(this._storage);

  @override
  Either<StorageRepositoryError, UploadTask> uploadFile(String path, String fileName, Uint8List bytes) {
    try {
      // TODO set a comprehensive filename for the file (at download file name is userUID + name)
      final ref = _storage.ref().child(path).child(fileName);
      final uploadTask = ref.putData(bytes);

      return Right<StorageRepositoryError, UploadTask>(uploadTask);
    } catch (e) {
      return Left<StorageRepositoryError, UploadTask>(StorageRepositoryError.technicalError("Error uploading file: $e"));
    }
  }

  @override
  Future<void> removeFile(String path) {
    try {
      return _storage.ref().child(path).delete();
    } catch (e) {
      throw StorageRepositoryError.technicalError("Error deleting file: $e");
    }
  }
}
