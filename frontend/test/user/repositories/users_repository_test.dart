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
      MockFirebaseDatabase.instance.ref().set(fakeData);

      test('should return user when user exists', () async {

        final userStream = repository.listenUserByUid('test-uid');

        expect(userStream, emits(isA<Right<UserRepositoryError, UserEntityModel>>().having((either) => either.right.uid, 'uid', 'test-uid')));
      });

      test('should throw exception when user does not exist', () async {

        final userStream = repository.listenUserByUid('fake-uid');

        expect(userStream, emits(isA<Left<UserRepositoryError, UserEntityModel>>().having((either) => either.left.errorType, 'errorType', UsersRepositoryErrorType.userNotFound)));
      });

    });

    group('addAvailableFile', () {
      test('should add file to available files', () async {

        const file = AvailableFileEntityModel(
          name: 'file',
          url: 'url',
        );

        await repository.addFileToAvailableFiles('test-uid', file)
          .onError((error, stackTrace) {
            fail('Error adding file to available files: $error');
          });

      });

      test('should add file to available files fails on missing user', () async {
        const file = AvailableFileEntityModel(
          name: 'file',
          url: 'url',
        );

        // TODO add a new mock to simulate the error

      });
    });
  });
}