part of 'share_links_bloc.dart';

abstract class ShareLinksState extends Equatable {
  const ShareLinksState();

  @override
  List<Object> get props => [];
}

class ShareLinksInitial extends ShareLinksState {
  const ShareLinksInitial();
}

class ShareLinksLoading extends ShareLinksState {
  const ShareLinksLoading();
}

class ShareLinkCreated extends ShareLinksState {
  final String linkUid;

  const ShareLinkCreated(this.linkUid);
}

class ShareLinkLoaded extends ShareLinksState {
  final List<String> fileUidList;

  const ShareLinkLoaded(this.fileUidList);
}

class ShareLinksError extends ShareLinksState {
  final String message;

  const ShareLinksError(this.message);
}