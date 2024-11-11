import 'package:flutter/material.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/theme.dart';
import 'package:greenshare/ui/widgets/card.dart';

class FileUploadSection extends StatelessWidget {
  const FileUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: GreenShareCard(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Click me', style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
          const SizedBox(width: kMaxPadding),
          Expanded(
            child: GreenShareCard(
              dottedBorder: true,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.cloud_upload),
                      iconSize: 48,
                      onPressed: () {},
                    ),
                    Text(
                      context.localization.importFile,
                      style: context.bodyLarge,
                    ),
                    Text(
                      context.localization.fileMaxSize(50),
                      style: context.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
