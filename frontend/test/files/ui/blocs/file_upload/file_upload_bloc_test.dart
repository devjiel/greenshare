import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/files/repositories/models/storage_repository_error.dart';
import 'package:greenshare/files/repositories/storage_repository.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorageRepository extends Mock implements StorageRepository {}

class UploadTaskMock extends Mock implements UploadTask {}
class TaskSnapshotMock extends Mock implements TaskSnapshot {}
class ReferenceMock extends Mock implements Reference {}

void main() {
  group('FileUploadBloc', () {
    final storageRepository = MockStorageRepository();
    late FileUploadBloc fileUploadBloc;

    setUp(() {
      fileUploadBloc = FileUploadBloc(storageRepository);
      registerFallbackValue(Uint8List(1));
    });

    tearDown(() {
      fileUploadBloc.close();
    });

    group('UploadFile', () {
      blocTest<FileUploadBloc, FileUploadState>(
        'emits [FileUploadInProgress, FileUploadInSuccess] when upload file',
        build: () => fileUploadBloc,
        setUp: () {
          final uploadTaskMock = UploadTaskMock();
          when(() => uploadTaskMock.snapshotEvents).thenAnswer((_) {
            final taskSnapshotMock = TaskSnapshotMock();
            when(() => taskSnapshotMock.bytesTransferred).thenReturn(1);
            when(() => taskSnapshotMock.totalBytes).thenReturn(2);
            final taskSnapshotMock2 = TaskSnapshotMock();
            when(() => taskSnapshotMock2.bytesTransferred).thenReturn(2);
            when(() => taskSnapshotMock2.totalBytes).thenReturn(2);
            return Stream.fromIterable([
              taskSnapshotMock,
              taskSnapshotMock2,
            ]);
          });

          final referenceMock = ReferenceMock();
          when(() => referenceMock.name).thenReturn('file1.pdf');
          when(() => referenceMock.fullPath).thenReturn('/path/file1.pdf');
          when(() => referenceMock.getDownloadURL()).thenAnswer((_) async => 'url');
          final doneTaskSnapshot = TaskSnapshotMock();
          when(() => doneTaskSnapshot.ref).thenReturn(referenceMock);
          when(() => doneTaskSnapshot.state).thenReturn(TaskState.success);
          when(() => doneTaskSnapshot.totalBytes).thenReturn(2);
          when(() => uploadTaskMock.snapshot).thenReturn(doneTaskSnapshot);
          when(() => storageRepository.uploadFile(any(), any(), any())).thenReturn(Right(uploadTaskMock));
        },
        act: (bloc) => bloc.add(UploadFile('path', 'file1.pdf', Uint8List(1))),
        expect: () => [
          const FileUploadInProgress(0.0, 'file1.pdf'),
          const FileUploadInProgress(0.5, 'file1.pdf'),
          const FileUploadInProgress(1.0, 'file1.pdf'),
          const FileUploaded('file1.pdf', 2.0, 'url', '/path/file1.pdf'),
        ],
      );

      blocTest<FileUploadBloc, FileUploadState>(
        'emits [FileUploadInFailure] when upload file fails',
        build: () => fileUploadBloc,
        setUp: () {
          when(() => storageRepository.uploadFile(any(), any(), any())).thenReturn(Left(StorageRepositoryError.technicalError('Upload failed')));
        },
        act: (bloc) => bloc.add(UploadFile('path', 'file1.pdf', Uint8List(1))),
        expect: () => [
          const FileUploadFailure('Upload failed'),
        ],
      );

      blocTest<FileUploadBloc, FileUploadState>(
        'emits [FileUploadInProgress, FileUploadInFailure] when upload file fails during upload',
        build: () => fileUploadBloc,
        setUp: () {
          final uploadTaskMock = UploadTaskMock();
          when(() => uploadTaskMock.snapshotEvents).thenAnswer((_) {
            return Stream.error('Upload failed');
          });
          var taskSnapshotMock = TaskSnapshotMock();
          when(() => taskSnapshotMock.state).thenReturn(TaskState.error);
          when(() => uploadTaskMock.snapshot).thenReturn(taskSnapshotMock);
          when(() => storageRepository.uploadFile(any(), any(), any())).thenReturn(Right(uploadTaskMock));
        },
        act: (bloc) => bloc.add(UploadFile('path', 'file1.pdf', Uint8List(1))),
        expect: () => [
          const FileUploadInProgress(0.0, 'file1.pdf'),
          const FileUploadFailure('Upload failed'),
        ],
      );
    });

    group('UploadConfigureExpiration', () {
      blocTest<FileUploadBloc, FileUploadState>(
        'emits [FileUploadedWithExpiration] when UploadConfigureExpiration is added',
        build: () => fileUploadBloc,
        seed: () => const FileRegistered(
          'file1.pdf',
          2.0,
          'url',
          '/path/file1.pdf',
          'fileUid',
        ),
        act: (bloc) => bloc.add(UploadConfigureExpiration(DateTime(2024, 11, 19))),
        expect: () => [
          FileUploadedWithExpiration(
            'file1.pdf',
            2.0,
            'url',
            '/path/file1.pdf',
            'fileUid',
            DateTime(2024, 11, 19),
          ),
        ],
      );

      blocTest<FileUploadBloc, FileUploadState>(
        'emits [FileUploadFailure] when UploadConfigureExpiration is added but state is not FileRegistered',
        build: () => fileUploadBloc,
        act: (bloc) => bloc.add(UploadConfigureExpiration(DateTime(2024, 11, 19))),
        expect: () => [
          const FileUploadFailure('File is not registered yet'),
        ],
      );
    });

    group('UploadFileRegistered', () {
      blocTest<FileUploadBloc, FileUploadState>(
        'emits [FileRegistered] when UploadFileRegistered is added and state is FileUploaded',
        build: () => fileUploadBloc,
        seed: () => const FileUploaded(
          'file1.pdf',
          2.0,
          'url',
          '/path/file1.pdf',
        ),
        act: (bloc) => bloc.add(const UploadFileRegistered('fileUid')),
        expect: () => [
          const FileRegistered(
            'file1.pdf',
            2.0,
            'url',
            '/path/file1.pdf',
            'fileUid',
          ),
        ],
      );

      blocTest<FileUploadBloc, FileUploadState>(
        'emits [FileUploadFailure] when UploadFileRegistered is added but state is not FileUploaded',
        build: () => fileUploadBloc,
        act: (bloc) => bloc.add(const UploadFileRegistered('fileUid')),
        expect: () => [
          const FileUploadFailure('File is not uploaded yet'),
        ],
      );
    });

    group('DeleteFile', () {
      blocTest<FileUploadBloc, FileUploadState>(
        'emits [FileDeleteFailure] when delete file fails',
        build: () => fileUploadBloc,
        setUp: () {
          when(() => storageRepository.removeFile(any())).thenAnswer((_) => Future.error('Delete failed'));
        },
        act: (bloc) => bloc.add(const DeleteFile('uid', 'path')),
        expect: () => [
          const FileDeleteFailure('Delete failed'),
        ],
      );

      blocTest<FileUploadBloc, FileUploadState>(
        'emits [FileDeleteSuccess] when delete file succeeds',
        build: () => fileUploadBloc,
        setUp: () {
          when(() => storageRepository.removeFile(any())).thenAnswer((_) => Future.value());
        },
        act: (bloc) => bloc.add(const DeleteFile('uid', 'path')),
        expect: () => [
          const FileDeleteSuccess('uid'),
        ],
      );
    });
  });
}