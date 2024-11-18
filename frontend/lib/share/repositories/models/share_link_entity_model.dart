
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/share/repositories/models/share_link_entity_model.freezed.dart';
part '../../../generated/share/repositories/models/share_link_entity_model.g.dart';

// TODO share link must have an expiration date

@freezed
class ShareLinkEntityModel with _$ShareLinkEntityModel {
    const factory ShareLinkEntityModel({
        required String uid,
        @JsonKey(name: 'file_uid_list') required List<String> fileUidList,
    }) = _ShareLinkEntityModel;

    factory ShareLinkEntityModel.fromJson(Map<String, Object?> json)
    => _$ShareLinkEntityModelFromJson(json);
}