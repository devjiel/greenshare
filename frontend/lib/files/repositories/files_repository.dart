import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:greenshare/files/repositories/models/file_entity_model.dart';
import 'package:injectable/injectable.dart';

abstract class FilesRepository {
  Future<List<FileEntityModel>> getFiles(List<String> fileIds);

  Future<String> saveFile(FileEntityModel file);

  Future<void> deleteFile(String fileId);
}

@LazySingleton(as: FilesRepository)
class FirebaseFilesRepository implements FilesRepository {
  final FirebaseDatabase _database;

  // TODO add crashlytics -> Test Proxy pattern
  FirebaseFilesRepository(@Named('firebaseDatabase') this._database);

  @override
  Future<List<FileEntityModel>> getFiles(List<String> fileIds) async {
    try {
      List<FileEntityModel> files = [];
      for (var fileId in fileIds) {
        await _database.ref().child('files').child(fileId).once().then((DatabaseEvent event) {
          if (event.snapshot.value != null) {
            files.add(FileEntityModel.fromJson(jsonDecode(jsonEncode(event.snapshot.value))));
          }
        });
      }
      return files;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<String> saveFile(FileEntityModel file) {
    try {
      return _database.ref().child('files').child(file.uid).set(file.toJson()).then((_) => file.uid);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> deleteFile(String fileId) {
    try {
      return _database.ref().child('files').child(fileId).remove();
    } catch (e) {
      return Future.error(e);
    }
  }
}
