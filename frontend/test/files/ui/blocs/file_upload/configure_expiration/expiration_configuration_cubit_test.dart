import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:greenshare/files/ui/blocs/file_upload/expiration_configuration/expiration_configuration_cubit.dart';

void main() {
  group('ExpirationConfigurationCubit', () {
    late ExpirationConfigurationCubit expirationConfigurationCubit;

    setUp(() {
      expirationConfigurationCubit = ExpirationConfigurationCubit();
    });

    test('initial state is ExpirationConfigurationState with default expirationType', () {
      expect(
          expirationConfigurationCubit.state,
          isA<ExpirationConfigurationState>()
              .having((state) => state.expirationType, 'expirationType', FileExpirationType.delay)
              .having((state) => state.delay, 'delay', isNull));
    });

    blocTest<ExpirationConfigurationCubit, ExpirationConfigurationState>(
      'emits [ExpirationConfigurationState] with updated expirationType when setExpirationType is called',
      build: () => expirationConfigurationCubit,
      act: (cubit) => cubit.setExpirationType(FileExpirationType.delay),
      expect: () => [const ExpirationConfigurationState(expirationType: FileExpirationType.delay)],
    );

    blocTest<ExpirationConfigurationCubit, ExpirationConfigurationState>(
      'emits [ExpirationConfigurationState] with updated delay when setDelay is called',
      build: () => expirationConfigurationCubit,
      act: (cubit) => cubit.setDelay(const Duration(days: 5)),
      expect: () => [const ExpirationConfigurationState(expirationType: FileExpirationType.delay, delay: Duration(days: 5))],
    );

    blocTest<ExpirationConfigurationCubit, ExpirationConfigurationState>(
      'emits nothing if try to set delay on expiration type other than delay',
      build: () => expirationConfigurationCubit,
      seed: () => const ExpirationConfigurationState(expirationType: FileExpirationType.atDownload),
      act: (cubit) => cubit.setDelay(const Duration(days: 5)),
      expect: () => [],
    );
  });
}
