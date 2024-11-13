part of 'available_files_bloc.dart';

abstract class AvailableFilesEvent extends Equatable {
  const AvailableFilesEvent();

  @override
  List<Object?> get props => [];
}

class LoadAvailableFilesEvent extends AvailableFilesEvent {
  const LoadAvailableFilesEvent({this.files});

  final List<AvailableFileViewModel>? files;
}