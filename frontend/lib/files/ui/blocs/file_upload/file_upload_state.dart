part of 'file_upload_bloc.dart';

abstract class FileUploadState extends Equatable {
  const FileUploadState();

  @override
  List<Object?> get props => [];
}

class FileUploadInitial extends FileUploadState {
  const FileUploadInitial();
}

class FileUploadInProgress extends FileUploadState {
  const FileUploadInProgress(this.progress, this.filename);

  final double progress;
  final String filename;

  @override
  List<Object> get props => [progress];
}

class FileUploaded extends FileUploadState {
  const FileUploaded(this.filename, this.fileSize, this.fileUrl, this.filePath);

  final String filename;
  final double fileSize;
  final String fileUrl;
  final String filePath;

  @override
  List<Object?> get props => [filename, fileSize, fileUrl, filePath];
}

class FileRegistered extends FileUploadState {
  const FileRegistered(this.filename, this.fileSize, this.fileUrl, this.filePath, this.fileUid);

  final String fileUid;
  final String filename;
  final double fileSize;
  final String fileUrl;
  final String filePath;

  @override
  List<Object?> get props => [fileUid, filename, fileSize, fileUrl, filePath];
}

class FileUploadedWithExpiration extends FileUploadState {
  const FileUploadedWithExpiration(this.filename, this.fileSize, this.fileUrl, this.filePath, this.fileUid, this.expirationDate);

  final String fileUid;
  final String filename;
  final double fileSize;
  final String fileUrl;
  final String filePath;
  final DateTime? expirationDate;

  @override
  List<Object?> get props => [filename, fileSize, fileUrl, filePath, expirationDate];
}

class FileDeleteSuccess extends FileUploadState {
  const FileDeleteSuccess(this.fileUid);

  final String fileUid;

  @override
  List<Object> get props => [fileUid];
}

class FileUploadFailure extends FileUploadState {
  final String error;

  const FileUploadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class FileDeleteFailure extends FileUploadState { // TODO should we mix two use case?
  final String error;

  const FileDeleteFailure(this.error);

  @override
  List<Object> get props => [error];
}