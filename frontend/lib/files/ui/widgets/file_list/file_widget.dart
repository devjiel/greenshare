import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.insert_drive_file_rounded,
            size: 32,
          ),
          const SizedBox(width: kSmallPadding),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.18, // TODO fix the layout to be responsive
                child: Text(
                  file.name,
                  style: context.labelLarge,
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
          const SizedBox(width: 16.0),
          (file.isOwnedByCurrentUser) ? IconButton(
            onPressed: () {
              context.read<FileUploadBloc>().add(DeleteFile(file.uid, file.path));
            },
            icon: const Icon(
              Icons.delete_rounded,
              size: 16,
            ),
          ) : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
