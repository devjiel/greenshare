import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:greenshare/user/repositories/models/models.dart';
import 'package:injectable/injectable.dart';

abstract class UsersRepository {
  // TODO rework Either pattern -> finally Future.error or Stream.onError working pretty well
  Stream<Either<UserRepositoryError, UserEntityModel>> listenUserByUid(String userId);

  Future<UserEntityModel> createUser(String userUid);

  Future<void> addFileToAvailableFiles(String userId, List<String> fileUid);

  Future<void> removeFileFromAvailableFiles(String userId, String fileUid);
}

@LazySingleton(as: UsersRepository)
class FirebaseUsersRepository implements UsersRepository {
  final FirebaseDatabase _database;

  FirebaseUsersRepository(@Named('firebaseDatabase') this._database);

  // TODO add crashlytics -> Test Proxy pattern

  @override
  Stream<Either<UserRepositoryError, UserEntityModel>> listenUserByUid(String userId) =>
      _database.ref().child('users').child(userId).onValue.map((event) {
        try {
          if (event.snapshot.value == null) {
            return Left<UserRepositoryError, UserEntityModel>(UserRepositoryError.userNotFound("User not found"));
          }

          // Tricks to have a correct json from firebase !!
          Map<String, dynamic> data = jsonDecode(jsonEncode(event.snapshot.value));
          return Right<UserRepositoryError, UserEntityModel>(UserEntityModel.fromJson(data));
        } catch (e) {
          return Left<UserRepositoryError, UserEntityModel>(UserRepositoryError.technicalError("Error getting user by id: $e"));
        }
      });

  @override
  Future<UserEntityModel> createUser(String userUid) async {
    try {
      final user = UserEntityModel(
        uid: userUid,
      );

      await _database.ref().child('users').child(userUid).set(user.toJson());

      return user;
    } catch (e) {
      return Future.error('Error creating user: $e');
    }
  }

  @override
  Future<void> addFileToAvailableFiles(String userId, List<String> fileUid) async {
    try {
      await _database.ref().child('users').child(userId).child('available_files').once().then((DatabaseEvent event) async {
        final existingFiles = jsonDecode(jsonEncode(event.snapshot.value)) ?? []; // TODO try push

        await _database.ref().child('users').child(userId).update({'available_files': [...existingFiles, ...fileUid.where((file) => !existingFiles.contains(file))]});
      });
    } catch (e) {
      return Future.error('Error adding file to available files: $e');
    }
  }

  @override
  Future<void> removeFileFromAvailableFiles(String userId, String fileUid) async {
    try {
      await _database.ref().child('users').child(userId).child('available_files').once().then((DatabaseEvent event) async {
        final existingFiles = jsonDecode(jsonEncode(event.snapshot.value)) ?? []; // TODO try push

        await _database.ref().child('users').child(userId).update({'available_files': existingFiles.where((file) => file != fileUid).toList()});
      });
    } catch (e) {
      return Future.error('Error removing file from available files: $e');
    }
  }
}
