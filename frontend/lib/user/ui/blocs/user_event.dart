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

final class CreateNewUser extends UserEvent {
  const CreateNewUser(this.userUid);

  final String userUid;
}

final class AddAvailableFile extends UserEvent {
  const AddAvailableFile({required this.fileUidList});

  final List<String> fileUidList;
}

final class RemoveAvailableFile extends UserEvent {
  const RemoveAvailableFile({required this.fileUid});

  final String fileUid;
}

final class _UserChanged extends UserEvent {
  const _UserChanged(this.user);

  final UserEntityModel user;
}

final class _UserError extends UserEvent {
  const _UserError(this.errorType);

  final UserErrorType errorType;
}

final class ResetUser extends UserEvent {
  const ResetUser();
}