
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'expiration_configuration_state.dart';

class ExpirationConfigurationCubit extends Cubit<ExpirationConfigurationState> {
  ExpirationConfigurationCubit() : super(const ExpirationConfigurationState(expirationType: FileExpirationType.delay));

  void setExpirationType(FileExpirationType expirationType) {
    emit(state.copyWith(expirationType: expirationType));
  }

  void setDelay(Duration? delay) {
    if (state.expirationType != FileExpirationType.delay) {
      return;
    }
    emit(state.copyWith(delay: delay));
  }
}
