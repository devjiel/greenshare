import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:greenshare/user/repositories/models/user_entity_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UsersRepository {
  final FirebaseDatabase _database;

  UsersRepository(@Named('firebaseDatabase') this._database);

  Stream<UserEntityModel?> listenToUser(String userId) {
    return _database.ref().child('users').child(userId).onValue.map((event) {
      try {
        if (event.snapshot.value == null) {
          return null;
        }

        // Tricks to have a correct json from firebase !!
        Map<String, dynamic> data = jsonDecode(jsonEncode(event.snapshot.value));
        return UserEntityModel.fromJson(data);
      } catch (e) {
        throw Exception('Error getting user');
      }
    });
  }
}
