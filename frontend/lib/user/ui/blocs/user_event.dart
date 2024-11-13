part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

final class StartListeningUser extends UserEvent {
  const StartListeningUser(this.userUid);

  final String userUid;
}

final class AddAvailableFile extends UserEvent {
  const AddAvailableFile({required this.name, required this.size, required this.expirationDate, required this.url});

  final String name;
  final double size;
  final DateTime expirationDate;
  final String url;
}

final class _UserChanged extends UserEvent {
  const _UserChanged(this.user);

  final UserEntityModel user;
}

final class _UserError extends UserEvent {
  const _UserError(this.errorType);

  final UserErrorType errorType;
}