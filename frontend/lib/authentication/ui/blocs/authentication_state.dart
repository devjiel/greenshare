part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated }

final class AuthenticationState extends Equatable {
  const AuthenticationState({AuthUserEntityModel user = AuthUserEntityModel.empty})
      : this._(
    status: user == AuthUserEntityModel.empty
        ? AuthenticationStatus.unauthenticated
        : AuthenticationStatus.authenticated,
    user: user,
  );

  const AuthenticationState._({required this.status, this.user = AuthUserEntityModel.empty});

  final AuthenticationStatus status;
  final AuthUserEntityModel user;

  @override
  List<Object> get props => [status, user];


}
