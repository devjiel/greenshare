import 'package:equatable/equatable.dart';
import 'package:greenshare/files/repositories/models/file_entity_model.dart';
import 'package:uuid/uuid.dart';

class FileViewModel extends Equatable {
  final String name;
  final double size;
  final DateTime? expirationDate;
  final String downloadUrl;
  final String ownerUid;

  const FileViewModel({
    required this.name,
    required this.size,
    required this.expirationDate,
    required this.downloadUrl,
    required this.ownerUid,
  });

  @override
  List<Object?> get props => [name, size, expirationDate, downloadUrl, ownerUid];

  static FileViewModel fromEntity(FileEntityModel file) {
    return FileViewModel(
      name: file.name,
      size: file.size,
      expirationDate: file.expirationDate,
      downloadUrl: file.downloadUrl,
      ownerUid: file.ownerUid,
    );
  }
}

extension AvailableFileViewModelExtension on FileViewModel {
  FileEntityModel toEntity() {
    return FileEntityModel(
      uid: const Uuid().v4(), // TODO no need to keep uid in view model ? -> method only used in save new file?
      name: name,
      size: size,
      expirationDate: expirationDate,
      downloadUrl: downloadUrl,
      ownerUid: ownerUid,
    );
  }
}
