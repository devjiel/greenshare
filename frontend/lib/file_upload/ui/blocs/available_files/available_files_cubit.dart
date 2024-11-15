import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/file_upload/repositories/files_repository.dart';
import 'package:greenshare/file_upload/ui/models/file_view_model.dart';
import 'package:injectable/injectable.dart';

part 'available_files_state.dart';

@singleton
class AvailableFilesCubit extends Cubit<AvailableFilesState> {

  AvailableFilesCubit(FilesRepository filesRepository) : _filesRepository = filesRepository, super(AvailableFilesInitial());

  final FilesRepository _filesRepository;

  void loadFiles(List<String>? fileUidList) async {
    if (fileUidList == null) {
      emit(AvailableFilesLoaded(const []));
      return;
    }

    _filesRepository.getFiles(fileUidList.map((uid) => uid).toList()).then((files) {
      List<FileViewModel> fileModels = files.map((file) => FileViewModel.fromEntity(file)).toList();
      fileModels.sort((a, b) {
        if (a.expirationDate == null) {
          return 1;
        }
        if (b.expirationDate == null) {
          return -1;
        }
        return b.expirationDate!.compareTo(a.expirationDate!);
      });

      emit(AvailableFilesLoaded(fileModels));
    });
  }

  Future<String> addAvailableFile(FileViewModel file) {
    return _filesRepository.saveFile(file.toEntity()); // TODO handle error
  }
}