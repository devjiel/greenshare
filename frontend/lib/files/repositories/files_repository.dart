import 'dart:convert';
import 'dart:developer' as developer;

import 'package:firebase_database/firebase_database.dart';
import 'package:greenshare/files/repositories/models/file_entity_model.dart';
import 'package:injectable/injectable.dart';

abstract class FilesRepository {
  Future<FileEntityModel> getFile(String fileId);

  Future<List<FileEntityModel>> getFiles(List<String> fileIds);

  Future<String> saveFile(FileEntityModel file);

  Future<void> deleteFile(String fileId);

  Future<void> updateExpirationDate(String fileId, int expirationDate);

  Future<void> addSharedWithUser(String fileId, String userId);
}

@LazySingleton(as: FilesRepository)
class FirebaseFilesRepository implements FilesRepository {
  final FirebaseDatabase _database;

  // TODO add crashlytics -> Test Proxy pattern
  FirebaseFilesRepository(@Named('firebaseDatabase') this._database);

  @override
  Future<FileEntityModel> getFile(String fileId) async {
    try {
      return _database.ref().child('files').child(fileId).once().then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          return FileEntityModel.fromJson(jsonDecode(jsonEncode(event.snapshot.value)));
        } else {
          throw Exception('File not found');
        }
      });
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
Future<List<FileEntityModel>> getFiles(List<String> fileIds) async {
  List<FileEntityModel> files = [];
  for (var fileId in fileIds) {
    try {
      await getFile(fileId).then((file) => files.add(file));
    } catch (e) {
      // TODO log error
      developer.log('Error getting file $fileId: $e', name: 'FilesRepository');
    }
  }
  return files;
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

  @override
  Future<void> updateExpirationDate(String fileId, int expirationDate) {
    try {
      return _database.ref().child('files').child(fileId).child('expiration_date').set(expirationDate);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> addSharedWithUser(String fileId, String userId) async {
    try {
      await _database.ref().child('files').child(fileId).child('shared_with').once().then((DatabaseEvent event) {
        final sharedWith = jsonDecode(jsonEncode(event.snapshot.value)) ?? [];
        if (!sharedWith.contains(userId)) { // TODO could check if user is not the owner
          _database.ref().child('files').child(fileId).update({
            'shared_with': [...sharedWith, userId]
          });
        }
      });
    } catch (e) {
      return Future.error(e);
    }
  }
}
