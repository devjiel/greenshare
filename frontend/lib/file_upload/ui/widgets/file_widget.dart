import 'package:flutter/material.dart';
import 'package:greenshare/theme.dart';

class FileWidget extends StatelessWidget {
  const FileWidget({super.key});

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
                "document.pdf",
                style: context.labelLarge,
              ),
              const SizedBox(height: 2.0),
              Row(
                children: [
                  Text(
                    "7.4 Mo",
                    style: context.labelSmall,
                  ),
                  Text(
                    "-",
                    style: context.labelSmall,
                  ),
                  Text(
                    "2024-11-20 11:54",
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
