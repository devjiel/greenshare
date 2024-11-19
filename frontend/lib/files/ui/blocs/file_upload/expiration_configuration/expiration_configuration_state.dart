
part of 'expiration_configuration_cubit.dart';

class ExpirationConfigurationState extends Equatable {

  const ExpirationConfigurationState({
    required this.expirationType,
    this.delay,
  });

  final FileExpirationType expirationType;
  final Duration? delay;

  ExpirationConfigurationState copyWith({
    FileExpirationType? expirationType,
    Duration? delay,
  }) {
    return ExpirationConfigurationState(
      expirationType: expirationType ?? this.expirationType,
      delay: delay ?? this.delay,
    );
  }

  @override
  List<Object?> get props => [expirationType, delay];
}



enum FileExpirationType {
  delay,
  atDownload,
}