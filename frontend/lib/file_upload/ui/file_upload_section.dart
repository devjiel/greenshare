import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:greenshare/common/ui/widgets/card.dart';
import 'package:greenshare/file_upload/ui/blocs/available_files/available_files_bloc.dart';
import 'package:greenshare/file_upload/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/file_upload/ui/widgets/file_list_widget.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/theme.dart';
import 'package:greenshare/user/ui/blocs/user_bloc.dart';

class FileUploadSection extends StatelessWidget {
  const FileUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    final fileUploadBloc = context.read<FileUploadBloc>();
    final availableFileBloc = context.read<AvailableFilesBloc>();
    late final DropzoneViewController controller;

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserStateLoaded) {
          availableFileBloc.add(LoadAvailableFilesEvent(files: state.user.files));
        }
        // TODO handle other states ?
      },
      child: Padding(
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
                  (kIsWeb) ? DropzoneView(
                    operation: DragOperation.copy,
                    onCreated: (ctrl) => controller = ctrl,
                    onDropFile: (file) async {
                      final fileBytes = await controller.getFileData(file);
                      fileUploadBloc.add(UploadFile('user-uid', file.name, fileBytes)); // TODO get user uid
                    },
                  ) : const SizedBox.shrink(),
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

                                if (fileBytes != null) {
                                  fileUploadBloc.add(UploadFile('user-uid', fileName, fileBytes)); // TODO get user uid
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
      ),
    );
  }
}
