part of 'file_upload_bloc.dart';

abstract class FileUploadState extends Equatable {
  const FileUploadState();

  @override
  List<Object> get props => [];
}

class FileUploadInitial extends FileUploadState {
  const FileUploadInitial();
}

class FileUploadInProgress extends FileUploadState {
  final double progress;

  const FileUploadInProgress(this.progress);

  @override
  List<Object> get props => [progress];
}

class FileUploadSuccess extends FileUploadState {
  const FileUploadSuccess(this.filename, this.fileSize, this.fileUrl);

  final String filename;
  final double fileSize;
  final String fileUrl;
}

class FileUploadFailure extends FileUploadState {
  final String error;

  const FileUploadFailure(this.error);

  @override
  List<Object> get props => [error];
}