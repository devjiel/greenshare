import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:greenshare/file_upload/repositories/storage_repository.dart';

part 'file_upload_event.dart';

part 'file_upload_state.dart';

@lazySingleton
class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  final StorageRepository _storageRepository;

  FileUploadBloc(this._storageRepository) : super(const FileUploadInitial()) {
    on<UploadFile>(_onUploadFile);
    on<UploadProgress>(_onUploadProgress);
    on<UploadFailure>(_onUploadFailure);
    on<UploadSuccess>(_onUploadSuccess);
  }

  Future<void> _onUploadFile(UploadFile event, Emitter<FileUploadState> emit) async {
    final result = _storageRepository.uploadFile(event.path, event.fileName, event.bytes);
    result.fold(
      (error) => add(UploadFailure(error.message)),
      (uploadTask) {
        emit(const FileUploadInProgress(0));

        uploadTask.snapshotEvents.listen((snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          add(UploadProgress(progress));
        })
          ..onError((error) {
            add(UploadFailure(error.toString()));
          })
          ..onDone(() {
            if (uploadTask.snapshot.state == TaskState.success) {
              add(UploadSuccess(uploadTask.snapshot.ref.name));
            }
          });
      },
    );
  }

  FutureOr<void> _onUploadFailure(UploadFailure event, Emitter<FileUploadState> emit) {
    emit(FileUploadFailure(event.message));
  }

  FutureOr<void> _onUploadSuccess(UploadSuccess event, Emitter<FileUploadState> emit) {
    emit(FileUploadSuccess(event.filename));
  }

  FutureOr<void> _onUploadProgress(UploadProgress event, Emitter<FileUploadState> emit) {
    emit(FileUploadInProgress(event.progress));
  }
}
