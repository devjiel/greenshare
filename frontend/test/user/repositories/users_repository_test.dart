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
    MockFirebaseDatabase.instance.ref().set(fakeData);
  });

  group('UsersRepository', () {
    group('listenUserByUid', () {

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

        final userStream = repository.listenUserByUid('test-uid');

        await repository.addFileToAvailableFiles('test-uid', ['uid3', 'uid4', 'uid5']).onError((error, stackTrace) {
          fail('Error adding file to available files: $error');
        });

        expect(
            userStream,
            emits(isA<Right<UserRepositoryError, UserEntityModel>>()
                .having((either) => either.right.uid, 'uid', 'test-uid')
                .having((either) => either.right.availableFiles, 'users\'s available files', ['uid1', 'uid2', 'uid3', 'uid4', 'uid5'])));

      });

      test('should add file to available files fails on missing user', () async {

        // TODO add a new mock to simulate the error
      });
    });

    group('removeAvailableFile', () {
      test('should delete file to available files', () async {

        final userStream = repository.listenUserByUid('test-uid');

        await repository.removeFileFromAvailableFiles('test-uid', 'uid2').onError((error, stackTrace) {
          fail('Error removing file to available files: $error');
        });

        expect(
            userStream,
            emits(isA<Right<UserRepositoryError, UserEntityModel>>()
                .having((either) => either.right.uid, 'uid', 'test-uid')
                .having((either) => either.right.availableFiles, 'users\'s available files', ['uid1', 'uid3'])));

      });

      test('should remove file to available files fails on missing user', () async {

        // TODO add a new mock to simulate the error
      });
    });
  });
}
