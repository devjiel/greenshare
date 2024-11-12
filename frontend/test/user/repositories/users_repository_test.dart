import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/user/repositories/models/models.dart';
import 'package:greenshare/user/repositories/users_repository.dart';

void main() {
  FirebaseDatabase firebaseDatabase = MockFirebaseDatabase.instance;
  const fakeData = {
    'users': {
      'test-uid': {
        'uid': 'test-uid',
      },
    }
  };
  late FirebaseUsersRepository repository;

  setUp(() {
    repository = FirebaseUsersRepository(firebaseDatabase);
  });

  group('UsersRepository', () {
    group('listenUserByUid', () {
      test('should return user when user exists', () async {
        MockFirebaseDatabase.instance.ref().set(fakeData);

        final userStream = repository.listenUserByUid('test-uid');

        expect(userStream, emits(isA<Right<UserRepositoryError, UserEntityModel>>().having((either) => either.right.uid, 'uid', 'test-uid')));
      });

      test('should throw exception when user does not exist', () async {
        MockFirebaseDatabase.instance.ref().set(fakeData);

        final userStream = repository.listenUserByUid('fake-uid');

        expect(userStream, emits(isA<Left<UserRepositoryError, UserEntityModel>>().having((either) => either.left.errorType, 'errorType', UsersRepositoryErrorType.userNotFound)));
      });

    });
  });
}