import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/common/ui/widgets/card.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_stepper_widget.dart';
import 'package:greenshare/theme.dart';

class FileUploadSuccessWidget extends StatelessWidget {
  const FileUploadSuccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GreenShareCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: BlocBuilder<FileUploadBloc, FileUploadState>(builder: (context, state) {
              if (state is FileUploadSuccess) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const FileUploadStepperWidget(
                    activeStep: 2,
                  ),
                  const SizedBox(height: kDefaultPadding * 1.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.insert_drive_file_rounded,
                        size: 32.0,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.filename,
                        style: context.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: kDefaultPadding),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<FileUploadBloc>().add(const UploadReset());
                        },
                        child:  Text('Next', style: kTextTheme.bodyLarge?.copyWith(color: kBlack)), // TODO localize
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
      ),
    );
    ;
  }
}
