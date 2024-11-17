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
        'available_files': ['uid1', 'uid2', 'uid3'],
      }
    }
  };

  late FirebaseUsersRepository repository;

  setUp(() {
    repository = FirebaseUsersRepository(firebaseDatabase);
  });

  group('UsersRepository', () {
    group('listenUserByUid', () {
      MockFirebaseDatabase.instance.ref().set(fakeData);

      test('should return user when user exists', () async {
        final userStream = repository.listenUserByUid('test-uid');

        expect(
            userStream,
            emits(isA<Right<UserRepositoryError, UserEntityModel>>()
                .having((either) => either.right.uid, 'uid', 'test-uid')
                .having((either) => either.right.availableFiles, 'users\'s available files', ['uid1', 'uid2', 'uid3'])));
      });

      test('should throw exception when user does not exist', () async {
        final userStream = repository.listenUserByUid('fake-uid');

        expect(
            userStream,
            emits(isA<Left<UserRepositoryError, UserEntityModel>>()
                .having((either) => either.left.errorType, 'errorType', UsersRepositoryErrorType.userNotFound)));
      });
    });

    group('addAvailableFile', () {
      test('should add file to available files', () async {

        await repository.addFileToAvailableFiles('test-uid', ['uid1', 'uid2']).onError((error, stackTrace) {
          fail('Error adding file to available files: $error');
        });

      });

      test('should add file to available files fails on missing user', () async {

        // TODO add a new mock to simulate the error
      });
    });
  });
}
