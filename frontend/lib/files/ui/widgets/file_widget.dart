import 'package:flutter/material.dart';
import 'package:greenshare/files/ui/models/file_view_model.dart';
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
                    context.localization.fileSize(file.size), // TODO size is in octets
                    style: context.labelSmall,
                  ),
                  Text(
                    "-",
                    style: context.labelSmall,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Icon(
                      Icons.timelapse_outlined,
                      size: 12.0,
                    ),
                  ),
                  (file.expirationDate != null) ? Text(
                    // TODO How to have only one parameter?
                    context.localization.fileExpirationDate(file.expirationDate!, file.expirationDate!),
                    style: context.labelSmall,
                  ) : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
