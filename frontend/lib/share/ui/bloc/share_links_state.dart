part of 'share_links_cubit.dart';

abstract class ShareLinksState {}

class ShareLinksInitial extends ShareLinksState {}

class ShareLinksLoading extends ShareLinksState {}

class ShareLinkCreated extends ShareLinksState {
  final String linkUid;

  ShareLinkCreated(this.linkUid);
}

class ShareLinkLoaded extends ShareLinksState {
  final List<String> fileUidList;

  ShareLinkLoaded(this.fileUidList);
}

class ShareLinksError extends ShareLinksState {
  final String message;

  ShareLinksError(this.message);
}