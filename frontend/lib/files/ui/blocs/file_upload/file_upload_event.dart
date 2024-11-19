part of 'file_upload_bloc.dart';

abstract class FileUploadEvent extends Equatable {
  const FileUploadEvent();

  @override
  List<Object?> get props => [];
}

class UploadFile extends FileUploadEvent {
  final String path;
  final String fileName;
  final Uint8List bytes;

  const UploadFile(this.path, this.fileName, this.bytes);

  @override
  List<Object> get props => [path, fileName, bytes];
}

class DeleteFile extends FileUploadEvent {
  const DeleteFile(this.fileUid, this.path);

  final String fileUid;
  final String path;

  @override
  List<Object> get props => [fileUid, path];
}

class UploadProgress extends FileUploadEvent {
  const UploadProgress(this.progress);

  final double progress;

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
  const UploadSuccess(this.filename, this.fileSize, this.fileUrl, this.filePath);

  final String filename;
  final double fileSize;
  final String fileUrl;
  final String filePath;

  @override
  List<Object> get props => [filename, fileSize, fileUrl, filePath];
}

class UploadFileRegistered extends FileUploadEvent {
  const UploadFileRegistered(this.fileUid);

  final String fileUid;

  @override
  List<Object> get props => [fileUid];
}

class UploadConfigureExpiration extends FileUploadEvent {
  const UploadConfigureExpiration(this.expirationDate);

  final DateTime? expirationDate;

  @override
  List<Object?> get props => [expirationDate];
}

class UploadReset extends FileUploadEvent {
  const UploadReset();
}