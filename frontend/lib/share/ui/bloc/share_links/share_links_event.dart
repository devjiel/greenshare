part of 'share_links_bloc.dart';

abstract class ShareLinksEvent extends Equatable {
  const ShareLinksEvent();

  @override
  List<Object> get props => [];
}

class CreateShareLink extends ShareLinksEvent {
  final List<String> files;

  const CreateShareLink(this.files);

  @override
  List<Object> get props => [files];
}

class GetShareLinkFiles extends ShareLinksEvent {
  final String linkUid;

  const GetShareLinkFiles(this.linkUid);

  @override
  List<Object> get props => [linkUid];
}