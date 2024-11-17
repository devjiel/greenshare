class ShareLinksRepositoryError extends Error {

  ShareLinksRepositoryError._({
    required this.errorType,
    required this.message,
  });

  final ShareLinksRepositoryErrorType errorType;
  final String message;

  static ShareLinksRepositoryError linkNotFound(String message) => ShareLinksRepositoryError._(
    errorType: ShareLinksRepositoryErrorType.linkNotFound,
    message: message,
  );

  static ShareLinksRepositoryError technicalError(String message) => ShareLinksRepositoryError._(
    errorType: ShareLinksRepositoryErrorType.technicalError,
    message: message,
  );
}

enum ShareLinksRepositoryErrorType {
  linkNotFound,
  technicalError,
}
