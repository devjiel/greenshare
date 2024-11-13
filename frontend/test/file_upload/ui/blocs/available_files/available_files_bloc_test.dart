import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/file_upload/ui/blocs/available_files/available_files_bloc.dart';
import 'package:greenshare/user/ui/models/available_file_view_model.dart';

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
      act: (bloc) => bloc.add(LoadAvailableFilesEvent(files: [
        AvailableFileViewModel(name: 'file1.pdf', size: 1.2, expirationDate: DateTime(2024, 11, 11)),
        AvailableFileViewModel(name: 'file2.pdf', size: 2.5, expirationDate: DateTime(2024, 11, 11)),
        AvailableFileViewModel(name: 'file3.pdf', size: 3.7, expirationDate: DateTime(2024, 11, 11)),
      ])),
      wait: const Duration(seconds: 3),
      expect: () => [
        isA<AvailableFilesLoaded>()
            .having((state) => state.files.length, 'files length', 3)
            .having((state) => state.files[0].name, 'file 1 name', 'file1.pdf')
            .having((state) => state.files[0].size, 'file 1 size', 1.2)
            .having((state) => state.files[0].expirationDate, 'file 1 expiration date', DateTime(2024, 11, 11))
            .having((state) => state.files[1].name, 'file 2 name', 'file2.pdf')
            .having((state) => state.files[1].size, 'file 2size', 2.5)
            .having((state) => state.files[1].expirationDate, 'file 2 expiration date', DateTime(2024, 11, 11))
            .having((state) => state.files[2].name, 'file 3 name', 'file3.pdf')
            .having((state) => state.files[2].size, 'file 3 size', 3.7)
            .having((state) => state.files[2].expirationDate, 'file 3 expiration date', DateTime(2024, 11, 11)),
      ],
    );
  });
}
