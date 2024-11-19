import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/files/repositories/models/file_entity_model.freezed.dart';
part '../../../generated/files/repositories/models/file_entity_model.g.dart';

@freezed
class FileEntityModel with _$FileEntityModel {
  const factory FileEntityModel({
    required String uid,
    required String name,
    required double size,
    required String downloadUrl, // TODO rename
    required String path,
    required String ownerUid, // TODO rename
    DateTime? expirationDate, // TODO rename
  }) = _FileEntityModel;

  factory FileEntityModel.fromJson(Map<String, Object?> json)
  => _$FileEntityModelFromJson(json);
}