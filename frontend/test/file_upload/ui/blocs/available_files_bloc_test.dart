import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/file_upload/ui/blocs/available_files_bloc.dart';

void main() {
  group('AvailableFilesBloc', () {
    late AvailableFilesBloc availableFilesBloc;

    setUp(() {
      availableFilesBloc = AvailableFilesBloc();
    });

    tearDown(() {
      availableFilesBloc.close();
    });

    blocTest<AvailableFilesBloc, AvailableFilesState>(
      'emits [AvailableFilesLoading, AvailableFilesLoaded] when loadFiles is called',
      build: () => availableFilesBloc,
      act: (bloc) => bloc.add(LoadAvailableFilesEvent()),
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
  });
}
