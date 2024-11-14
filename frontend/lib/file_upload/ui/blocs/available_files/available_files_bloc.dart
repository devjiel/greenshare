import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/user/ui/models/available_file_view_model.dart';
import 'package:injectable/injectable.dart';

part 'available_files_event.dart';
part 'available_files_state.dart';

// TODO: Transform it to Cubit? wait until database model is stable
@singleton
class AvailableFilesBloc extends Bloc<AvailableFilesEvent, AvailableFilesState> {

  AvailableFilesBloc() : super(AvailableFilesInitial()) {
    on<LoadAvailableFilesEvent>((event, emit) => _loadFiles(event, emit));
  }

  void _loadFiles(LoadAvailableFilesEvent event, Emitter<AvailableFilesState> emit) async {
    emit(AvailableFilesLoaded(event.files ?? []));
  }
}