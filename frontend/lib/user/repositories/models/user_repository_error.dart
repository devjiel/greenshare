class UserRepositoryError {

  const UserRepositoryError._({
    required this.errorType,
    required this.message,
  });

  final UsersRepositoryErrorType errorType;
  final String message;

  static UserRepositoryError userNotFound(String message) => UserRepositoryError._(
    errorType: UsersRepositoryErrorType.userNotFound,
    message: message,
  );

  static UserRepositoryError technicalError(String message) => UserRepositoryError._(
    errorType: UsersRepositoryErrorType.technicalError,
    message: message,
  );
}

enum UsersRepositoryErrorType {
  userNotFound,
  technicalError,
}
