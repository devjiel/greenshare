part of '../available_files_bloc.dart';

class FileViewModel extends Equatable {
  final String name;
  final double size;
  final DateTime expirationDate;

  const FileViewModel({
    required this.name,
    required this.size,
    required this.expirationDate,
  });

  @override
  List<Object?> get props => [name, size, expirationDate];
}