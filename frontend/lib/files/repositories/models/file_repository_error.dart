class FileRepositoryError {

  const FileRepositoryError._({
    required this.errorType,
    required this.message,
  });

  final FileRepositoryErrorType errorType;
  final String message;

  static FileRepositoryError technicalError(String message) => FileRepositoryError._(
    errorType: FileRepositoryErrorType.technicalError,
    message: message,
  );
}

enum FileRepositoryErrorType {
  technicalError,
}
