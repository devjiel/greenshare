import 'package:equatable/equatable.dart';

class AuthUserEntityModel extends Equatable {
  final String id;
  final String? email;
  final String? name;

  const AuthUserEntityModel({
    required this.id,
    this.email,
    this.name,
  });

  static const empty = AuthUserEntityModel(id: '');

  @override
  List<Object?> get props => [id, email, name];
}