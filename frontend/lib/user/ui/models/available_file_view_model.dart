import 'package:equatable/equatable.dart';
import 'package:greenshare/user/repositories/models/available_file_entity_model.dart';

class AvailableFileViewModel extends Equatable {
  final String name;
  final double size;
  final DateTime expirationDate;

  const AvailableFileViewModel({
    required this.name,
    required this.size,
    required this.expirationDate,
  });

  @override
  List<Object?> get props => [name, size, expirationDate];

  static fromEntity(AvailableFileEntityModel file) {
    return AvailableFileViewModel(
      name: file.name,
      size: 0.0, // TODO
      expirationDate: DateTime.now().add(const Duration(days: 1)), // TODO
    );
  }
}
