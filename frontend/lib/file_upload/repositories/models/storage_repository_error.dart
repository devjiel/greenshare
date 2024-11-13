class StorageRepositoryError {

  const StorageRepositoryError._({
    required this.message,
  });

  final String message;

  static StorageRepositoryError technicalError(String message) {
    return StorageRepositoryError._(
      message: message,
    );
  }
}
