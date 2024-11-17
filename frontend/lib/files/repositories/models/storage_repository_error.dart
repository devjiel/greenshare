import 'package:equatable/equatable.dart';

class StorageRepositoryError extends Equatable {

  const StorageRepositoryError._({
    required this.message,
  });

  final String message;

  static StorageRepositoryError technicalError(String message) {
    return StorageRepositoryError._(
      message: message,
    );
  }

  @override
  List<Object?> get props => [message];
}
