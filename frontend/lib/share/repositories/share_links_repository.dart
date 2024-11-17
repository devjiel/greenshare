import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:greenshare/share/repositories/models/share_link_entity_model.dart';
import 'package:greenshare/share/repositories/models/share_links_repository_error.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract class ShareLinksRepository {
  Future<ShareLinkEntityModel> getLink(String linkUid);

  Future<String> createLink(List<String> files);
}

@LazySingleton(as: ShareLinksRepository)
class FirebaseShareLinksRepository implements ShareLinksRepository {
  final FirebaseDatabase _database;

  // TODO add crashlytics -> Test Proxy pattern
  FirebaseShareLinksRepository(@Named('firebaseDatabase') this._database);

  @override
  Future<String> createLink(List<String> files) {
    final linkUid = const Uuid().v4();
    return _database.ref().child('shares').child(linkUid).update(ShareLinkEntityModel(uid: linkUid, fileUidList: files).toJson()).then(
      (_) => linkUid,
    );
  }

  @override
  Future<ShareLinkEntityModel> getLink(String linkUid) {
    return _database.ref().child('shares').child(linkUid).once().then(
      (DatabaseEvent event) {
        if (event.snapshot.value != null) {
          return ShareLinkEntityModel.fromJson(jsonDecode(jsonEncode(event.snapshot.value)));
        } else {
          throw ShareLinksRepositoryError.linkNotFound('Link not found');
        }
      },
    );
  }
}
