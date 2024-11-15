import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenshare/file_upload/repositories/models/storage_repository_error.dart';
import 'package:greenshare/file_upload/repositories/storage_repository.dart';
import 'package:greenshare/file_upload/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorageRepository extends Mock implements StorageRepository {}

class UploadTaskMock extends Mock implements UploadTask {}
class TaskSnapshotMock extends Mock implements TaskSnapshot {}
class ReferenceMock extends Mock implements Reference {}

void main() {
  group('AvailableFilesBloc', () {
    final storageRepository = MockStorageRepository();
    late FileUploadBloc fileUploadBloc;

    setUp(() {
      fileUploadBloc = FileUploadBloc(storageRepository);
      registerFallbackValue(Uint8List(1));
    });

    tearDown(() {
      fileUploadBloc.close();
    });

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
        const FileUploadInProgress(0.0),
        const FileUploadInProgress(0.5),
        const FileUploadInProgress(1.0),
        const FileUploadSuccess('file1.pdf', 2.0, 'url'),
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
        const FileUploadInProgress(0.0),
        const FileUploadFailure('Upload failed'),
      ],
    );
  });
}