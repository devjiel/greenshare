import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:greenshare/common/config/injectable.dart';
import 'package:greenshare/common/ui/widgets/card.dart';
import 'package:greenshare/file_upload/ui/widgets/file_list_widget.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/theme.dart';

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
            child: const FileListWidget(),
          ),
          const SizedBox(width: kMaxPadding),
          Expanded(
            child: Stack(
              children: [
                // TODO: https://pub.dev/packages/flutter_dropzone
                DropzoneView(
                  operation: DragOperation.copy,
                  onDropFile: (file) {
                    print('Received file: ${file.name}');
                  },
                ),
                GreenShareCard(
                  dottedBorder: true,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.cloud_upload),
                          iconSize: 48,
                          onPressed: () async {
                            // TODO https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup
                            // TODO https://pub.dev/packages/file_picker
                            final result = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: false);

                            if (result != null && result.files.isNotEmpty) {
                              final fileBytes = result.files.first.bytes;
                              final fileName = result.files.first.name;

                              // upload file
                              if (fileBytes != null) {
                                final uploadTask = getIt<FirebaseStorage>().ref('user-uid/$fileName').putData(fileBytes);
                                uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
                                  print('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
                                });
                                await uploadTask;
                              }
                            }
                          },
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
