part of 'available_files_bloc.dart';

abstract class AvailableFilesState extends Equatable {}

class AvailableFilesInitial extends AvailableFilesState {
  @override
  List<Object?> get props => [];
}

class AvailableFilesLoading extends AvailableFilesState {
  @override
  List<Object?> get props => [];
}

class AvailableFilesLoaded extends AvailableFilesState {
  final List<FileViewModel> files;

  AvailableFilesLoaded(this.files);

  @override
  List<Object?> get props => [files];
}

class AvailableFilesError extends AvailableFilesState {
  final String message;

  AvailableFilesError(this.message);

  @override
  List<Object?> get props => [message];
}