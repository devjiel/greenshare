import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/files/ui/blocs/available_files/available_files_cubit.dart';
import 'package:greenshare/files/ui/blocs/file_upload/expiration_configuration/expiration_configuration_cubit.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/files/ui/models/file_view_model.dart';
import 'package:greenshare/files/ui/widgets/file_list/file_list_widget.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_configure_share_widget.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_in_progress_widget.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_stepper_widget.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_configure_expiration_widget.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_widget.dart';
import 'package:greenshare/share/ui/bloc/share_links/share_links_bloc.dart';
import 'package:greenshare/theme.dart';
import 'package:greenshare/user/ui/blocs/user_bloc.dart';
import 'package:uuid/uuid.dart';

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
            if (state is FileUploaded) {
              // Add file to available files
              availableFilesCubit
                  .saveFile(
                FileViewModel(
                  uid: const Uuid().v4(),
                  name: state.filename,
                  size: state.fileSize,
                  expirationDate: DateTime.now().add(const Duration(days: 1)),
                  // TODO add update expiration date
                  downloadUrl: state.fileUrl,
                  path: state.filePath,
                  ownerUid: (userBloc.state as UserStateLoaded).user.uid,
                  // TODO user bloc state should be checked
                  isOwnedByCurrentUser: true,
                ),
              )
                  .then(
                // Link file to user
                (fileUid) {
                  context.read<FileUploadBloc>().add(UploadFileRegistered(fileUid));
                  userBloc.add(AddAvailableFile(fileUidList: [fileUid]));
                },
              );
            } else if (state is FileDeleteSuccess) {
              availableFilesCubit.deleteFile(state.fileUid);
              userBloc.add(RemoveAvailableFile(fileUid: state.fileUid));
              // TODO remove available files of other users
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
            Expanded(
              child: BlocBuilder<FileUploadBloc, FileUploadState>(
                builder: (context, state) {
                  if (state is FileUploadInProgress) {
                    return const FileUploadInProgressWidget();
                  } else if (state is FileUploaded || state is FileRegistered) {
                    return BlocProvider<ExpirationConfigurationCubit>.value(
                      value: ExpirationConfigurationCubit(),
                      child: const FileUploadConfigureExpirationWidget(),
                    );
                  } else if (state is FileUploadedWithExpiration) {
                    return const FileUploadConfigureShareWidget();
                  } else {
                    return const FileUploadWidget();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
