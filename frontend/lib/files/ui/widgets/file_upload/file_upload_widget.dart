import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:greenshare/common/ui/widgets/card.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/theme.dart';
import 'package:greenshare/user/ui/blocs/user_bloc.dart';

class FileUploadWidget extends StatelessWidget {
  const FileUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final fileUploadBloc = context.read<FileUploadBloc>();
    late final DropzoneViewController controller;

    return BlocBuilder<UserBloc, UserState>(builder: (context, userState) {
      final userUid = (userState is UserStateLoaded) ? userState.user.uid : null;
      return Stack(
        children: [
          (kIsWeb)
              ? DropzoneView(
                  operation: DragOperation.copy,
                  onCreated: (ctrl) => controller = ctrl,
                  onDropFile: (file) async {
                    final fileBytes = await controller.getFileData(file);
                    if (userUid != null) {
                      fileUploadBloc.add(UploadFile(userUid, file.name, fileBytes));
                    }
                  },
                )
              : const SizedBox.shrink(),
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
                      // TODO https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup -> need to add permission for android and ios
                      final result = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: false);

                      if (result != null && result.files.isNotEmpty) {
                        final fileBytes = result.files.first.bytes;
                        final fileName = result.files.first.name;

                        if (userUid != null && fileBytes != null) {
                          fileUploadBloc.add(UploadFile(userUid, fileName, fileBytes));
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
      );
    });
  }
}
