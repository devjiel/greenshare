import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/files/ui/blocs/available_files/available_files_cubit.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/files/ui/models/file_view_model.dart';
import 'package:greenshare/files/ui/widgets/file_list_widget.dart';
import 'package:greenshare/files/ui/widgets/file_upload_widget.dart';
import 'package:greenshare/share/ui/bloc/share_links/share_links_bloc.dart';
import 'package:greenshare/theme.dart';
import 'package:greenshare/user/ui/blocs/user_bloc.dart';

class FileSection extends StatelessWidget {
  const FileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FileUploadBloc, FileUploadState>(
          listener: (context, state) {
            final userBloc = context.read<UserBloc>();
            final availableFilesCubit = context.read<AvailableFilesCubit>();
            final shareLinksCubit = context.read<ShareLinksBloc>();
            if (state is FileUploadSuccess) {
              // Add file to available files
              availableFilesCubit
                  .addAvailableFile(
                    FileViewModel(
                      name: state.filename,
                      size: state.fileSize,
                      expirationDate: DateTime.now().add(const Duration(days: 1)), // TODO get expiration date
                      downloadUrl: state.fileUrl,
                      ownerUid: (userBloc.state as UserStateLoaded).user.uid, // TODO user bloc state should be checked
                    ),
                  )
                  .then(
                    // Link file to user
                    (fileUid) {
                      userBloc.add(AddAvailableFile(fileUidList: [fileUid]));
                      shareLinksCubit.add(CreateShareLink([fileUid]));
                    },
                  );
            }
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              height: double.infinity,
              child: const FileListWidget(),
            ),
            const SizedBox(width: kMaxPadding),
            const Expanded(
              child: FileUploadWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
