import 'package:equatable/equatable.dart';
import 'package:greenshare/user/repositories/models/user_entity_model.dart';
import 'package:greenshare/user/ui/models/available_file_view_model.dart';

class UserViewModel extends Equatable {
  const UserViewModel({required this.uid, this.files});

  final String uid;
  final List<AvailableFileViewModel>? files;

  @override
  List<Object?> get props => [uid, files];

  static UserViewModel fromEntity(UserEntityModel user) {
    return UserViewModel(
      uid: user.uid,
      files: user.availableFiles?.map<AvailableFileViewModel>((file) => AvailableFileViewModel.fromEntity(file)).toList(),
    );
  }
}
