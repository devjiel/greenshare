import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/user/repositories/models/user_entity_model.dart';
import 'package:greenshare/user/repositories/models/user_repository_error.dart';
import 'package:greenshare/user/repositories/users_repository.dart';
import 'package:greenshare/user/ui/blocs/user_bloc.dart';
import 'package:greenshare/user/ui/models/user_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockUsersRepository extends Mock implements FirebaseUsersRepository {}

void main() {
  group('UserBloc', () {
    final usersRepository = MockUsersRepository();
    late UserBloc userBloc;

    setUp(() {
      userBloc = UserBloc(userRepository: usersRepository);
    });

    tearDown(() {
      userBloc.close();
    });

    group('StartListeningUser', () {
      blocTest<UserBloc, UserState>(
        'emits [UserStateLoading, UserStateLoaded] when StartListeningUser is called and user is found',
        build: () => userBloc,
        setUp: () {
          when(() => usersRepository.listenUserByUid('userUid')).thenAnswer((_) => Stream.value(const Right(UserEntityModel(uid: 'userUid'))));
        },
        act: (bloc) => bloc.add(const StartListeningUser('userUid')),
        expect: () => [const UserStateLoading(), isA<UserStateLoaded>().having((state) => state.user.uid, 'user uid', 'userUid')],
        verify: (_) {
          verify(() => usersRepository.listenUserByUid('userUid')).called(1);
        },
      );

      blocTest<UserBloc, UserState>(
        'emits [UserStateLoading, UserStateError] when StartListeningUser is called and user is not found',
        build: () => userBloc,
        setUp: () {
          when(() => usersRepository.listenUserByUid('fakeUserUid'))
              .thenAnswer((_) => Stream.value(Left(UserRepositoryError.userNotFound('user not found'))));
        },
        act: (bloc) => bloc.add(const StartListeningUser('fakeUserUid')),
        expect: () => [const UserStateLoading(), isA<UserStateError>().having((state) => state.errorType, 'error type', UserErrorType.userNotFound)],
        verify: (_) {
          verify(() => usersRepository.listenUserByUid('fakeUserUid')).called(1);
        },
      );

      blocTest<UserBloc, UserState>(
        'emits [UserStateLoading, UserStateError] when StartListeningUser is called and repository encounters a technical error',
        build: () => userBloc,
        setUp: () {
          when(() => usersRepository.listenUserByUid('userUid'))
              .thenAnswer((_) => Stream.value(Left(UserRepositoryError.technicalError('technical error'))));
        },
        act: (bloc) => bloc.add(const StartListeningUser('userUid')),
        expect: () => [
          const UserStateLoading(),
          isA<UserStateError>().having((state) => state.errorType, 'error type', UserErrorType.errorWhileRetrievingUser)
        ],
        verify: (_) {
          verify(() => usersRepository.listenUserByUid('userUid')).called(1);
        },
      );
    });

    group('CreateNewUser', () {
      blocTest<UserBloc, UserState>(
        'emits [UserStateError] when CreateNewUser is called and repository encounters a technical error',
        build: () => userBloc,
        setUp: () {
          when(() => usersRepository.createUser('userUid')).thenAnswer((_) => Future.error('technical error'));
        },
        act: (bloc) {
          userBloc.add(const CreateNewUser('userUid'));
        },
        expect: () => [isA<UserStateError>().having((state) => state.errorType, 'error type', UserErrorType.errorCreatingUser)],
        verify: (_) {
          verify(() => usersRepository.createUser('userUid')).called(1);
        },
      );

      blocTest<UserBloc, UserState>(
        'emits [UserStateLoaded] when CreateNewUser is called and repository creates user successfully',
        build: () => userBloc,
        setUp: () {
          when(() => usersRepository.createUser('userUid')).thenAnswer((_) => Future.value(const UserEntityModel(uid: 'userUid')));
          when(() => usersRepository.listenUserByUid('userUid')).thenAnswer((_) => Stream.value(const Right(UserEntityModel(uid: 'userUid'))));
        },
        act: (bloc) {
          userBloc.add(const CreateNewUser('userUid'));
        },
        expect: () => [const UserStateLoading(), isA<UserStateLoaded>().having((state) => state.user.uid, 'user uid', 'userUid')],
        verify: (_) {
          verify(() => usersRepository.createUser('userUid')).called(1);
        },
      );
    });

    group('ResetUser', () {
      blocTest<UserBloc, UserState>(
        'emits [UserStateInitial] when ResetUser is called',
        build: () => userBloc,
        act: (bloc) {
          userBloc.add(const ResetUser());
        },
        expect: () => [const UserStateInitial()],
      );
    });

    group('AddAvailableFile', () {
      blocTest<UserBloc, UserState>(
        'emits [UserStateError] when AddAvailableFile is called and state is not UserStateLoaded',
        build: () => userBloc,
        act: (bloc) => bloc.add(const AddAvailableFile(fileUidList: ['fileUid'])),
        expect: () => [isA<UserStateError>().having((state) => state.errorType, 'error type', UserErrorType.errorWhileAddingFile)],
      );

      blocTest<UserBloc, UserState>(
        'emits [UserStateError] when AddAvailableFile is called and repository encounters a technical error',
        build: () => userBloc,
        setUp: () {
          when(() => usersRepository.addFileToAvailableFiles('userUid', ['fileUid']))
              .thenAnswer((_) => Future.error('technical error'));
        },
        seed: () => const UserStateLoaded(UserViewModel(uid: 'userUid')),
        act: (bloc) {
          userBloc.add(const AddAvailableFile(fileUidList: ['fileUid']));
        },
        expect: () => [isA<UserStateError>().having((state) => state.errorType, 'error type', UserErrorType.errorWhileAddingFile)],
        verify: (_) {
          verify(() => usersRepository.addFileToAvailableFiles('userUid', ['fileUid'])).called(1);
        },
      );

      blocTest<UserBloc, UserState>(
        'emits [UserStateLoaded] when AddAvailableFile is called and repository adds file successfully',
        build: () => userBloc,
        setUp: () {
          when(() => usersRepository.addFileToAvailableFiles('userUid', ['fileUid'])).thenAnswer((_) => Future.value());
        },
        seed: () => const UserStateLoaded(UserViewModel(uid: 'userUid')),
        act: (bloc) {
          userBloc.add(const AddAvailableFile(fileUidList: ['fileUid']));
        },
        expect: () => [],
        verify: (_) {
          verify(() => usersRepository.addFileToAvailableFiles('userUid', ['fileUid'])).called(1);
        },
      );
    });

    group('RemoveAvailableFile', () {
      blocTest<UserBloc, UserState>(
        'emits [UserStateError] when RemoveAvailableFile is called and state is not UserStateLoaded',
        build: () => userBloc,
        act: (bloc) => bloc.add(const RemoveAvailableFile(fileUid: 'fileUid')),
        expect: () => [isA<UserStateError>().having((state) => state.errorType, 'error type', UserErrorType.errorWhileRemovingFile)],
      );

      blocTest<UserBloc, UserState>(
        'emits [UserStateError] when RemoveAvailableFile is called and repository encounters a technical error',
        build: () => userBloc,
        setUp: () {
          when(() => usersRepository.removeFileFromAvailableFiles('userUid', 'fileUid'))
              .thenAnswer((_) => Future.error('technical error'));
        },
        seed: () => const UserStateLoaded(UserViewModel(uid: 'userUid')),
        act: (bloc) {
          userBloc.add(const RemoveAvailableFile(fileUid: 'fileUid'));
        },
        expect: () => [isA<UserStateError>().having((state) => state.errorType, 'error type', UserErrorType.errorWhileRemovingFile)],
        verify: (_) {
          verify(() => usersRepository.removeFileFromAvailableFiles('userUid', 'fileUid')).called(1);
        },
      );

      blocTest<UserBloc, UserState>(
        'emits [UserStateLoaded] when RemoveAvailableFile is called and repository removes file successfully',
        build: () => userBloc,
        setUp: () {
          when(() => usersRepository.removeFileFromAvailableFiles('userUid', 'fileUid')).thenAnswer((_) => Future.value());
        },
        seed: () => const UserStateLoaded(UserViewModel(uid: 'userUid')),
        act: (bloc) {
          userBloc.add(const RemoveAvailableFile(fileUid: 'fileUid'));
        },
        expect: () => [],
        verify: (_) {
          verify(() => usersRepository.removeFileFromAvailableFiles('userUid', 'fileUid')).called(1);
        },
      );
    });
  });
}
