part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];

  static const initial = UserStateInitial();

  static const loading = UserStateLoading();

  static UserStateLoaded loaded(UserViewModel user) {
    return UserStateLoaded(user);
  }

  static UserStateError error(UserErrorType errorType) {
    return UserStateError(errorType);
  }
}

class UserStateInitial extends UserState {
  const UserStateInitial();
}

class UserStateLoading extends UserState {
  const UserStateLoading();
}

class UserStateLoaded extends UserState {
  final UserViewModel user;

  const UserStateLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserStateError extends UserState {
  final UserErrorType errorType;

  const UserStateError(this.errorType);

  @override
  List<Object?> get props => [errorType];
}

enum UserErrorType {
  userNotFound,
  errorWhileRetrievingUser,
  errorWhileAddingFile,
  errorWhileRemovingFile, errorCreatingUser,
}
