import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/user/repositories/models/user_entity_model.dart';
import 'package:greenshare/user/repositories/models/user_repository_error.dart';
import 'package:greenshare/user/repositories/users_repository.dart';
import 'package:greenshare/user/ui/blocs/user_bloc.dart';
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
        when(() => usersRepository.listenUserByUid('fakeUserUid')).thenAnswer((_) => Stream.value(Left(UserRepositoryError.userNotFound('user not found'))));
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
        when(() => usersRepository.listenUserByUid('userUid')).thenAnswer((_) => Stream.value(Left(UserRepositoryError.technicalError('technical error'))));
      },
      act: (bloc) => bloc.add(const StartListeningUser('userUid')),
      expect: () => [const UserStateLoading(), isA<UserStateError>().having((state) => state.errorType, 'error type', UserErrorType.errorWhileRetrievingUser)],
      verify: (_) {
        verify(() => usersRepository.listenUserByUid('userUid')).called(1);
      },
    );
  });
}
