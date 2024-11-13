import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/user/repositories/models/available_file_entity_model.freezed.dart';
part '../../../generated/user/repositories/models/available_file_entity_model.g.dart';

@freezed
class AvailableFileEntityModel with _$AvailableFileEntityModel {
  const factory AvailableFileEntityModel({
    required String name,
    required String url,
  }) = _AvailableFileEntityModel;

  factory AvailableFileEntityModel.fromJson(Map<String, Object?> json)
  => _$AvailableFileEntityModelFromJson(json);
}