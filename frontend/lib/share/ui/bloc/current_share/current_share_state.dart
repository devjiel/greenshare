part of 'current_share_cubit.dart';

class CurrentShareState extends Equatable {
  final String? shareLink;

  const CurrentShareState(this.shareLink);

  @override
  List<Object?> get props => [shareLink];
}