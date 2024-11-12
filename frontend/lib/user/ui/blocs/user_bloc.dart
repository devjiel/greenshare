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
    on<_UserChanged>(_onUserChanged);
    on<_UserError>(_onError);
  }

  final UsersRepository _userRepository;
  late StreamSubscription<UserEvent> _userSubscription;

  @override
  Future<void> close() {
    _userSubscription.cancel();
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
                  case UsersRepositoryErrorType.technicalError:
                    return const _UserError(UserErrorType.technicalError);
                }
              },
              (user) => _UserChanged(user),
            ))
        .handleError((error) {
      add(const _UserError(UserErrorType.technicalError));
    }).listen((event) => add(event));
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
