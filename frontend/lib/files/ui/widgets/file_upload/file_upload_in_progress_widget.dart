import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/common/ui/widgets/card.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_stepper_widget.dart';
import 'package:greenshare/theme.dart';

class FileUploadInProgressWidget extends StatelessWidget {
  const FileUploadInProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GreenShareCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: BlocBuilder<FileUploadBloc, FileUploadState>(
              builder: (context, state) {
                if (state is FileUploadInProgress) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const FileUploadStepperWidget(),
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
                      LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(8),
                        value: state.progress,
                      ),
                      const Spacer(),
                    ],
                  );
                }
                return const SizedBox.shrink(); // TODO handle this case
              }
            ),
          ),
        ),
      ),
    );
  }
}
