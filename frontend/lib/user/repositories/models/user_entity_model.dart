import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:greenshare/user/repositories/models/available_file_entity_model.dart';

part '../../../generated/user/repositories/models/user_entity_model.freezed.dart';
part '../../../generated/user/repositories/models/user_entity_model.g.dart';

@freezed
class UserEntityModel with _$UserEntityModel {
  const factory UserEntityModel({
    required String uid,
    List<AvailableFileEntityModel>? availableFiles,
  }) = _UserEntityModel;

  factory UserEntityModel.fromJson(Map<String, Object?> json)
  => _$UserEntityModelFromJson(json);
}