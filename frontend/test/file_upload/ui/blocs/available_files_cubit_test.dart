import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/file_upload/ui/blocs/available_files_cubit.dart';

void main() {
  group('AvailableFilesCubit', () {
    late AvailableFilesCubit availableFilesCubit;

    setUp(() {
      availableFilesCubit = AvailableFilesCubit();
    });

    tearDown(() {
      availableFilesCubit.close();
    });

    blocTest<AvailableFilesCubit, AvailableFilesState>(
      'emits [AvailableFilesLoading, AvailableFilesLoaded] when loadFiles is called',
      build: () => availableFilesCubit,
      act: (cubit) => cubit.loadFiles(),
      wait: const Duration(seconds: 3),
      expect: () => [
        AvailableFilesLoading(),
        isA<AvailableFilesLoaded>()
            .having((state) => state.files.length, 'files length', 3)
            .having((state) => state.files[0].name, 'name', 'file1.pdf')
            .having((state) => state.files[0].size, 'size', 1.2)
            .having((state) => state.files[1].name, 'name', 'file2.pdf')
            .having((state) => state.files[1].size, 'size', 2.5)
            .having((state) => state.files[2].name, 'name', 'file3.pdf')
            .having((state) => state.files[2].size, 'size', 3.7),
      ],
    );

    blocTest<AvailableFilesCubit, AvailableFilesState>(
      'emits [AvailableFilesError] when showError is called',
      build: () => availableFilesCubit,
      act: (cubit) => cubit.showError('An error occurred'),
      expect: () => [
        AvailableFilesError('An error occurred'),
      ],
    );
  });
}
