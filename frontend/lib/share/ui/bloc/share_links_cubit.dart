import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/share/repositories/share_links_repository.dart';
import 'package:injectable/injectable.dart';

part 'share_links_state.dart';

@singleton
class ShareLinksCubit extends Cubit<ShareLinksState> {
  final ShareLinksRepository _repository;

  ShareLinksCubit(this._repository) : super(ShareLinksInitial());

  Future<void> createShareLink(List<String> files) async {
    try {
      emit(ShareLinksLoading());
      final linkUid = await _repository.createLink(files);
      emit(ShareLinkCreated(_generateShareLink(linkUid)));
    } catch (e) {
      emit(ShareLinksError(e.toString()));
    }
  }

  Future<void> getShareLinkFiles(String linkUid) async {
    try {
      emit(ShareLinksLoading());
      final shareLink = await _repository.getLink(linkUid);
      emit(ShareLinkLoaded(shareLink.fileUidList));
    } catch (e) {
      emit(ShareLinksError(e.toString()));
    }
  }

  String _generateShareLink(String shareUid) {
    return '/share/$shareUid';
  }
}
