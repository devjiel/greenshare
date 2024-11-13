import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:greenshare/file_upload/repositories/storage_repository.dart';

part 'file_upload_event.dart';

part 'file_upload_state.dart';

@injectable
class FileUploadBloc extends Bloc<FileUploadEvent, FileUploadState> {
  final StorageRepository _storageRepository;

  FileUploadBloc(this._storageRepository) : super(FileUploadInitial()) {
    on<UploadFile>(_onUploadFile);
    on<UploadProgress>(_onUploadProgress);
    on<UploadFailure>(_onUploadFailure);
    on<UploadSuccess>(_onUploadSuccess);
  }

  Future<void> _onUploadFile(UploadFile event, Emitter<FileUploadState> emit) async {
    final result = _storageRepository.uploadFile(event.path, event.fileName, event.bytes);
    result.fold(
      (error) => emit(FileUploadFailure(error.message)),
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
            add(const UploadSuccess());
          });
      },
    );
  }

  FutureOr<void> _onUploadFailure(UploadFailure event, Emitter<FileUploadState> emit) {
    emit(FileUploadFailure(event.message));
  }

  FutureOr<void> _onUploadSuccess(UploadSuccess event, Emitter<FileUploadState> emit) {
    emit(const FileUploadSuccess());
  }

  FutureOr<void> _onUploadProgress(UploadProgress event, Emitter<FileUploadState> emit) {
    emit(FileUploadInProgress(event.progress));
  }
}
