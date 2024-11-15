import 'package:equatable/equatable.dart';
import 'package:greenshare/user/repositories/models/user_entity_model.dart';

class UserViewModel extends Equatable {
  const UserViewModel({required this.uid, this.files});

  final String uid;
  final List<String>? files;

  @override
  List<Object?> get props => [uid, files];

  static UserViewModel fromEntity(UserEntityModel user) {
    return UserViewModel(
      uid: user.uid,
      files: user.availableFiles?.map((file) => file).toList(),
    );
  }
}
