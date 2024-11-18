import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'current_share_state.dart';

@singleton
class CurrentShareCubit extends Cubit<String?> {
  CurrentShareCubit() : super(null);

  void storeShareLink(String shareLink) {
    emit(shareLink);
  }

  void clearShareLink() {
    emit(null);
  }
}
