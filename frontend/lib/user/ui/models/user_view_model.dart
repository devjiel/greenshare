import 'package:equatable/equatable.dart';

class UserViewModel extends Equatable {
  const UserViewModel(this.uid);

  final String uid;

  @override
  List<Object> get props => [uid];

}
