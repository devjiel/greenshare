import 'package:equatable/equatable.dart';
import 'package:greenshare/user/repositories/models/user_entity_model.dart';

class UserViewModel extends Equatable {
  const UserViewModel({required this.uid});

  final String uid;

  @override
  List<Object> get props => [uid];

  static UserViewModel fromEntity(UserEntityModel user) {
    return UserViewModel(uid: user.uid);
  }

}
