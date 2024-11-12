import 'package:flutter/material.dart';
import 'package:greenshare/file_upload/ui/models/file_view_model.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/theme.dart';

class FileWidget extends StatelessWidget {
  const FileWidget({super.key, required this.file});

  final FileViewModel file;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kSmallPadding),
      child: Row(
        children: [
          const Icon(
            Icons.insert_drive_file_rounded,
            size: 32,
          ),
          const SizedBox(width: kSmallPadding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                file.name,
                style: context.labelLarge,
              ),
              const SizedBox(height: 2.0),
              Row(
                children: [
                  Text(
                    context.localization.fileSize(file.size),
                    style: context.labelSmall,
                  ),
                  Text(
                    "-",
                    style: context.labelSmall,
                  ),
                  Text(
                    // How to have only one parameter?
                    context.localization.fileExpirationDate(file.expirationDate, file.expirationDate),
                    style: context.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
