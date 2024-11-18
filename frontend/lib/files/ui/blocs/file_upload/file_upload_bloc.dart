import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:greenshare/files/repositories/storage_repository.dart';

part 'file_upload_event.dart';

part 'file_upload_state.dart';

@lazySingleton
class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  final StorageRepository _storageRepository;

  FileUploadBloc(this._storageRepository) : super(const FileUploadInitial()) {
    on<UploadFile>(_onUploadFile);
    on<DeleteFile>(_onDeleteFile);
    on<UploadProgress>(_onUploadProgress);
    on<UploadFailure>(_onUploadFailure);
    on<UploadSuccess>(_onUploadSuccess);
    on<UploadReset>(_onUploadReset);
  }

  Future<void> _onUploadFile(UploadFile event, Emitter<FileUploadState> emit) async {
    // TODO limit file size
    final result = _storageRepository.uploadFile(event.path, event.fileName, event.bytes);
    result.fold(
      (error) => add(UploadFailure(error.message)),
      (uploadTask) {
        emit(FileUploadInProgress(0, event.fileName));

        uploadTask.snapshotEvents.listen((snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          add(UploadProgress(progress));
        })
          ..onError((error) {
            add(UploadFailure(error.toString()));
          })
          ..onDone(() async {
            if (uploadTask.snapshot.state == TaskState.success) {
              add(UploadSuccess(
                uploadTask.snapshot.ref.name,
                uploadTask.snapshot.totalBytes.toDouble(),
                await uploadTask.snapshot.ref.getDownloadURL(),
                uploadTask.snapshot.ref.fullPath,
              ));
            }
          });
      },
    );
  }

  Future<void> _onDeleteFile(DeleteFile event, Emitter<FileUploadState> emit) async {
    try {
      await _storageRepository.removeFile(event.path);
    } catch (e) {
      emit(FileDeleteFailure(e.toString()));
      return;
    }
    emit(FileDeleteSuccess(event.fileUid));
  }

  FutureOr<void> _onUploadFailure(UploadFailure event, Emitter<FileUploadState> emit) {
    emit(FileUploadFailure(event.message));
  }

  FutureOr<void> _onUploadSuccess(UploadSuccess event, Emitter<FileUploadState> emit) {
    emit(FileUploadSuccess(
      event.filename,
      event.fileSize,
      event.fileUrl,
      event.filePath,
    ));
  }

  Future<void> _onUploadProgress(UploadProgress event, Emitter<FileUploadState> emit) async {
    if (state is! FileUploadInProgress) {
      return;
    }
    final fileName = (state as FileUploadInProgress).filename;
    emit(FileUploadInProgress(event.progress, fileName));
  }

  Future<void> _onUploadReset(UploadReset event, Emitter<FileUploadState> emit) async {
    emit(const FileUploadInitial());
  }
}
