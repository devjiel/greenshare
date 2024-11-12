import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:greenshare/user/repositories/models/models.dart';
import 'package:injectable/injectable.dart';

abstract class UsersRepository {
  Stream<Either<UserRepositoryError, UserEntityModel>> listenUserByUid(String userId);
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
}
