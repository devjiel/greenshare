import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/common/ui/widgets/card.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_stepper_widget.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/share/ui/bloc/share_links/share_links_bloc.dart';
import 'package:greenshare/theme.dart';

class FileUploadConfigureShareWidget extends StatelessWidget {
  const FileUploadConfigureShareWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GreenShareCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: BlocBuilder<FileUploadBloc, FileUploadState>(builder: (context, state) {
            if (state is FileUploadedWithExpiration) {
              return Column(
                children: [
                  const FileUploadStepperWidget(
                    activeStep: 3,
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.localization.shareWithLink, style: kTextTheme.bodyLarge),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: BlocBuilder<ShareLinksBloc, ShareLinksState>(builder: (context, state) {
                            return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: kDarkGreen),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      (state is ShareLinkCreated)
                                          ? SelectableText(
                                              Uri.base.replace(fragment: state.linkUid).toString(), // TODO Deeplink URL ?,
                                              style: kTextTheme.bodySmall,
                                            )
                                          : const Spacer(),
                                      BlocBuilder<ShareLinksBloc, ShareLinksState>(builder: (context, state) {
                                        if (state is ShareLinkCreated) {
                                          return IconButton(
                                            icon: const Icon(
                                              Icons.copy,
                                              size: 16,
                                            ),
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(text: Uri.base.replace(fragment: state.linkUid).toString())); // TODO Deeplink URL ?,
                                            },
                                          );
                                        } else if (state is ShareLinksLoading) {
                                          return const CircularProgressIndicator();
                                        } else if (state is ShareLinksInitial) {
                                          return IconButton(
                                            icon: const Icon(
                                              Icons.refresh_rounded,
                                              size: 16,
                                            ),
                                            onPressed: () {
                                              final fileUploadBloc = context.read<FileUploadBloc>();
                                              if (fileUploadBloc.state is FileUploadedWithExpiration) {
                                                context.read<ShareLinksBloc>().add(
                                                      CreateShareLink(
                                                        [(fileUploadBloc.state as FileUploadedWithExpiration).fileUid],
                                                      ),
                                                    );
                                              }
                                            },
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      }),
                                    ],
                                  ),
                                ));
                          }),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<FileUploadBloc>().add(const UploadReset());
                          context.read<ShareLinksBloc>().add(const ResetShareLink());
                        },
                        child: Text(context.localization.done, style: kTextTheme.bodyLarge?.copyWith(color: kBlack)),
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
