import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/user/repositories/models/models.dart';
import 'package:greenshare/user/repositories/users_repository.dart';
import 'package:greenshare/user/ui/models/user_view_model.dart';
import 'package:injectable/injectable.dart';

part 'user_event.dart';

part 'user_state.dart';

@lazySingleton
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required UsersRepository userRepository,
  })  : _userRepository = userRepository,
        super(const UserStateInitial()) {
    on<StartListeningUser>(_onStartListeningUser);
    on<AddAvailableFile>(_onAddAvailableFile);
    on<RemoveAvailableFile>(_onRemoveAvailableFile);
    on<_UserChanged>(_onUserChanged);
    on<_UserError>(_onError);
  }

  final UsersRepository _userRepository;
  StreamSubscription<UserEvent>? _userSubscription;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onStartListeningUser(StartListeningUser event, Emitter<dynamic> emit) {
    emit(const UserStateLoading());
    _userSubscription = _userRepository
        .listenUserByUid(event.userUid)
        .map((either) => either.fold(
              (error) {
                switch (error.errorType) {
                  case UsersRepositoryErrorType.userNotFound:
                    return const _UserError(UserErrorType.userNotFound);
                  default:
                    return const _UserError(UserErrorType.errorWhileRetrievingUser);
                }
              },
              (user) => _UserChanged(user),
            ))
        .handleError((error) {
      add(const _UserError(UserErrorType.errorWhileRetrievingUser));
    }).listen((event) => add(event));
  }

  Future<void> _onAddAvailableFile(AddAvailableFile event, Emitter<UserState> emit) async {
    if (state is! UserStateLoaded) {
      emit(const UserStateError(UserErrorType.errorWhileAddingFile));
      return;
    }

    final user = (state as UserStateLoaded).user;
    _userRepository
        .addFileToAvailableFiles(
            user.uid,
            event.fileUidList)
        .onError((error, stackTrace) {
      emit(const UserStateError(UserErrorType.errorWhileAddingFile)); // TODO this on error seems to cause emit after event handler completed
    });
  }

  Future<void> _onRemoveAvailableFile(RemoveAvailableFile event, Emitter<UserState> emit) async {
    if (state is! UserStateLoaded) {
      emit(const UserStateError(UserErrorType.errorWhileRemovingFile));
      return;
    }

    final user = (state as UserStateLoaded).user;
    _userRepository
        .removeFileFromAvailableFiles(
            user.uid,
            event.fileUid)
        .onError((error, stackTrace) {
      emit(const UserStateError(UserErrorType.errorWhileRemovingFile)); // TODO this on error seems to cause emit after event handler completed
    });
  }

  void _onUserChanged(
    _UserChanged event,
    Emitter<UserState> emit,
  ) {
    emit(UserState.loaded(UserViewModel.fromEntity(event.user)));
  }

  void _onError(_UserError event, Emitter<UserState> emit) {
    emit(UserState.error(event.errorType));
  }
}
