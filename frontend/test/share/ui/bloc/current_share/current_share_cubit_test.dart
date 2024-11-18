import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:greenshare/share/ui/bloc/current_share/current_share_cubit.dart';

void main() {
  group('CurrentShareCubit', () {
    late CurrentShareCubit currentShareCubit;

    setUp(() {
      currentShareCubit = CurrentShareCubit();
    });

    test('initial state is null', () {
      expect(currentShareCubit.state, isNull);
    });

    blocTest<CurrentShareCubit, String?>(
      'emits [shareLink] when storeShareLink is called',
      build: () => currentShareCubit,
      act: (cubit) => cubit.storeShareLink('/share/test-link'),
      expect: () => ['/share/test-link'],
    );

    blocTest<CurrentShareCubit, String?>(
      'emits [null] when clearShareLink is called',
      build: () => currentShareCubit,
      seed: () => '/share/test-link',
      act: (cubit) {
        cubit.clearShareLink();
      },
      expect: () => [null],
    );
  });
}