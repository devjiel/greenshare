import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:greenshare/authentication/repositories/authentication_repository.dart';
import 'package:greenshare/authentication/repositories/models/auth_user_entity_model.dart';
import 'package:greenshare/authentication/ui/blocs/authentication/authentication_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

void main() {
  group('AuthenticationBloc', () {
    late AuthenticationRepository authenticationRepository;
    late AuthenticationBloc authenticationBloc;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      authenticationBloc = AuthenticationBloc(authenticationRepository: authenticationRepository);
    });

    test('initial state is AuthenticationState(user: AuthUserEntityModel.empty)', () {
      expect(authenticationBloc.state, AuthenticationState(user: AuthUserEntityModel.empty));
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits new state when AuthenticationSubscriptionRequested is added',
      build: () {
        when(() => authenticationRepository.user).thenAnswer((_) => Stream.value(const AuthUserEntityModel(id: '1')));
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(const AuthenticationSubscriptionRequested()),
      expect: () => [AuthenticationState(user: const AuthUserEntityModel(id: '1'))],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'calls logout on AuthenticationRepository when AuthenticationLogoutRequested is added',
      build: () {
        when(() => authenticationRepository.logout()).thenAnswer((_) async {});
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(const AuthenticationLogoutRequested()),
      verify: (_) {
        verify(() => authenticationRepository.logout()).called(1);
      },
    );
  });
}