import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class AvailableFilesCubit extends Cubit<AvailableFilesState> {
  AvailableFilesCubit() : super(AvailableFilesInitial());

  void loadFiles() {
    emit(AvailableFilesLoading());
    // Simulate a delay for loading files
    Future.delayed(const Duration(seconds: 2), () {
      // Simulate loaded files
      final files = [
        FileState(
          name: 'file1.pdf',
          size: 1.2,
          expirationDate: DateTime.now().add(const Duration(days: 30)),
        ),
        FileState(
          name: 'file2.pdf',
          size: 2.5,
          expirationDate: DateTime.now().add(const Duration(days: 15)),
        ),
        FileState(
          name: 'file3.pdf',
          size: 3.7,
          expirationDate: DateTime.now().add(const Duration(days: 45)),
        ),
      ];
      emit(AvailableFilesLoaded(files));
    });
  }

  void showError(String message) {
    emit(AvailableFilesError(message));
  }
}

abstract class AvailableFilesState {}

class AvailableFilesInitial extends AvailableFilesState {}

class AvailableFilesLoading extends AvailableFilesState {}

class AvailableFilesLoaded extends AvailableFilesState {
  final List<FileState> files;

  AvailableFilesLoaded(this.files);
}

class AvailableFilesError extends AvailableFilesState {
  final String message;

  AvailableFilesError(this.message);
}

class FileState {
  final String name;
  final double size;
  final DateTime expirationDate;

  FileState({
    required this.name,
    required this.size,
    required this.expirationDate,
  });
}