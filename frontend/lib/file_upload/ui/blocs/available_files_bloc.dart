import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'models/file_view_model.dart';
part 'available_files_event.dart';
part 'available_files_state.dart';

@singleton
class AvailableFilesBloc extends Bloc<AvailableFilesEvent, AvailableFilesState> {

  AvailableFilesBloc() : super(AvailableFilesInitial()) {
    on<LoadAvailableFilesEvent>((event, emit) => _loadFiles(emit));
  }

  void _loadFiles(Emitter<AvailableFilesState> emit) async {
    emit(AvailableFilesLoading());
    // Simulate a delay for loading files
    await Future.delayed(const Duration(seconds: 2), () {
      // Simulate loaded files
      final files = [
        FileViewModel(
          name: 'file1.pdf',
          size: 1.2,
          expirationDate: DateTime.now().add(const Duration(days: 30)),
        ),
        FileViewModel(
          name: 'file2.pdf',
          size: 2.5,
          expirationDate: DateTime.now().add(const Duration(days: 15)),
        ),
        FileViewModel(
          name: 'file3.pdf',
          size: 3.7,
          expirationDate: DateTime.now().add(const Duration(days: 45)),
        ),
      ];
      emit(AvailableFilesLoaded(files));
    });
  }
}