import 'package:equatable/equatable.dart';
import 'package:greenshare/files/repositories/models/file_entity_model.dart';

class FileViewModel extends Equatable {
  final String uid;
  final String name;
  final double size;
  final DateTime? expirationDate;
  final String downloadUrl;
  final String path;
  final String ownerUid; // TODO not needed in view model - have name or email instead
  final bool isOwnedByCurrentUser;

  const FileViewModel({
    required this.uid,
    required this.name,
    required this.size,
    required this.expirationDate,
    required this.downloadUrl,
    required this.path,
    required this.ownerUid,
    required this.isOwnedByCurrentUser,
  });


  @override
  List<Object?> get props => [name, size, expirationDate, downloadUrl, ownerUid];

  static FileViewModel fromEntity(FileEntityModel file, String userUid) {
    return FileViewModel(
      uid: file.uid,
      name: file.name,
      size: file.size,
      expirationDate: file.expirationDate,
      downloadUrl: file.downloadUrl,
      path: file.path,
      ownerUid: file.ownerUid,
      isOwnedByCurrentUser: file.ownerUid == userUid,
    );
  }
}

extension AvailableFileViewModelExtension on FileViewModel {
  FileEntityModel toEntity() {
    return FileEntityModel(
      uid: uid,
      name: name,
      size: size,
      expirationDate: expirationDate,
      downloadUrl: downloadUrl,
      path: path,
      ownerUid: ownerUid,
    );
  }
}
