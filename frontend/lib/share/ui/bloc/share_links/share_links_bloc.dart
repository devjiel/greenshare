import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/share/repositories/share_links_repository.dart';
import 'package:injectable/injectable.dart';

part 'share_links_event.dart';
part 'share_links_state.dart';

@singleton
class ShareLinksBloc extends Bloc<ShareLinksEvent, ShareLinksState> {
  final ShareLinksRepository _repository;

  ShareLinksBloc(this._repository) : super(ShareLinksInitial()) {
    on<CreateShareLink>(_onCreateShareLink);
    on<GetShareLinkFiles>(_onGetShareLinkFiles);
  }

  Future<void> _onCreateShareLink(CreateShareLink event, Emitter<ShareLinksState> emit) async {
    try {
      emit(ShareLinksLoading());
      final linkUid = await _repository.createLink(event.files);
      emit(ShareLinkCreated(_generateShareLink(linkUid)));
    } catch (e) {
      emit(ShareLinksError(e.toString()));
    }
  }

  Future<void> _onGetShareLinkFiles(GetShareLinkFiles event, Emitter<ShareLinksState> emit) async {
    try {
      emit(ShareLinksLoading());
      final shareLink = await _repository.getLink(event.linkUid);
      emit(ShareLinkLoaded(shareLink.fileUidList));
    } catch (e) {
      emit(ShareLinksError(e.toString()));
    }
  }

  String _generateShareLink(String shareUid) {
    return '/share/$shareUid';
  }
}
