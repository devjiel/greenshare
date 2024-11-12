import 'package:equatable/equatable.dart';

class AuthenticationError extends Equatable {
  const AuthenticationError(this.message);
    final String message;

    @override
    List<Object> get props => [message];
}
