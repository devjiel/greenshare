import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/common/ui/widgets/card.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_stepper_widget.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/theme.dart';

class FileUploadSuccessWidget extends StatelessWidget {
  const FileUploadSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GreenShareCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: BlocBuilder<FileUploadBloc, FileUploadState>(builder: (context, state) {
            if (state is FileUploadSuccess) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FileUploadStepperWidget(
                    activeStep: 2,
                  ),
                  const SizedBox(height: kDefaultPadding),
                  const _ExpirationRadioGroup(),
                  const SizedBox(height: kDefaultPadding),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<FileUploadBloc>().add(const UploadReset());
                        },
                        child: Text('Next', style: kTextTheme.bodyLarge?.copyWith(color: kBlack)), // TODO localize
                      ),
                    ],
                  ),
                ],
              );
            }
            return const SizedBox.shrink(); // TODO handle this case
          }),
        ),
      ),
    );
  }
}

enum FileExpirationType {
  delay,
  atDownload,
}

class _ExpirationRadioGroup extends StatefulWidget {
  const _ExpirationRadioGroup({super.key});

  @override
  State<_ExpirationRadioGroup> createState() => _ExpirationRadioGroupState();
}

class _ExpirationRadioGroupState extends State<_ExpirationRadioGroup> {
  FileExpirationType? _fileExpirationType = FileExpirationType.delay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            context.localization.setExpirationDate,
            style: context.bodyLarge,
          ),
          leading: Radio<FileExpirationType>(
            value: FileExpirationType.delay,
            groupValue: _fileExpirationType,
            onChanged: (FileExpirationType? value) {
              setState(() {
                _fileExpirationType = value;
              });
            },
          ),
        ),
        ListTile(
          title: Text(
            context.localization.deleteWhenContactDownloadIt,
            style: context.bodyLarge,
          ),
          leading: Radio<FileExpirationType>(
            value: FileExpirationType.atDownload,
            groupValue: _fileExpirationType,
            onChanged: (FileExpirationType? value) {
              setState(() {
                _fileExpirationType = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
