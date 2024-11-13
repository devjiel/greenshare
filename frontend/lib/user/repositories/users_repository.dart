import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:greenshare/user/repositories/models/models.dart';
import 'package:injectable/injectable.dart';

abstract class UsersRepository {
  // TODO rework Either pattern -> finally Future.error or Stream.onError working pretty well
  Stream<Either<UserRepositoryError, UserEntityModel>> listenUserByUid(String userId);

  Future<void> addFileToAvailableFiles(String userId, AvailableFileEntityModel file);
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
  Future<void> addFileToAvailableFiles(String userId, AvailableFileEntityModel file) async {
    try {
      await _database.ref().child('users').child(userId).child('availableFiles').push().set(file.toJson());
    } catch (e) {
      return Future.error('Error adding file to available files: $e');
    }
  }
}
