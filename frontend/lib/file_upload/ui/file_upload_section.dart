import 'package:flutter/material.dart';
import 'package:greenshare/file_upload/ui/widgets/file_widget.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: double.infinity,
            child: GreenShareCard(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.localization.availableDocuments,
                      style: context.bodyLarge,
                    ),
                    const SizedBox(height: 12.0),
                    const Padding(
                      padding: EdgeInsets.all(kSmallPadding),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            FileWidget(),
                            FileWidget(),
                            FileWidget(),
                            FileWidget(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
