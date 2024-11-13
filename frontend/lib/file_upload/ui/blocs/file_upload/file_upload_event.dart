part of 'file_upload_bloc.dart';

abstract class FileUploadEvent extends Equatable {
  const FileUploadEvent();

  @override
  List<Object> get props => [];
}

class UploadFile extends FileUploadEvent {
  final String path;
  final String fileName;
  final Uint8List bytes;

  const UploadFile(this.path, this.fileName, this.bytes);

  @override
  List<Object> get props => [path, fileName, bytes];
}

class UploadProgress extends FileUploadEvent {
  final double progress;

  const UploadProgress(this.progress);

  @override
  List<Object> get props => [progress];
}

class UploadFailure extends FileUploadEvent {
  final String message;

  const UploadFailure(this.message);

  @override
  List<Object> get props => [message];
}

class UploadSuccess extends FileUploadEvent {
  const UploadSuccess();
}
