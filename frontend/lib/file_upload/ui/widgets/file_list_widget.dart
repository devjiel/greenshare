import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/common/ui/widgets/card.dart';
import 'package:greenshare/file_upload/ui/blocs/available_files/available_files_cubit.dart';
import 'package:greenshare/file_upload/ui/widgets/file_widget.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/theme.dart';

class FileListWidget extends StatelessWidget {
  const FileListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GreenShareCard(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.localization.availableDocuments,
              style: context.bodyLarge,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(kSmallPadding),
                child: SingleChildScrollView(
                  child: BlocBuilder<AvailableFilesCubit, AvailableFilesState>(
                    builder: (context, state) {
                      if (state is AvailableFilesError) {
                        return Text(
                          'Error: ${state.message}',
                          style: context.bodySmall?.copyWith(color: kRed),
                        );
                      } else if (state is AvailableFilesLoaded) {
                        if (state.files.isEmpty) {
                          return Text(context.localization.noAvailableDocuments, style: context.bodySmall);
                        } else {
                          return Column(
                            children: state.files.map((file) => FileWidget(file: file)).toList(),
                          );
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
