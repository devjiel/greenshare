import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/common/ui/widgets/card.dart';
import 'package:greenshare/common/ui/widgets/loading_widget.dart';
import 'package:greenshare/files/ui/blocs/file_upload/expiration_configuration/expiration_configuration_cubit.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_stepper_widget.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/theme.dart';

class FileUploadConfigureExpirationWidget extends StatelessWidget {
  const FileUploadConfigureExpirationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GreenShareCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: BlocBuilder<FileUploadBloc, FileUploadState>(builder: (context, state) {
            if (state is FileRegistered) {
              return Column(
                children: [
                  const FileUploadStepperWidget(
                    activeStep: 2,
                  ),
                  const Flexible(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ExpirationRadioGroup(),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      BlocBuilder<ExpirationConfigurationCubit, ExpirationConfigurationState>(builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              if (state.delay == null) {
                                context.read<FileUploadBloc>().add(const UploadConfigureExpiration(null));
                                return;
                              }

                              final expirationDateTime = DateTime.now().add(state.delay!);
                              context.read<FileUploadBloc>().add(UploadConfigureExpiration(expirationDateTime));
                            },
                            child: Text(context.localization.next, style: kTextTheme.bodyLarge?.copyWith(color: kBlack)),
                          );
                        }
                      ),
                    ],
                  ),
                ],
              );
            }
            return const Center(
              child: LoadingWidget(),
            ); // TODO handle this case
          }),
        ),
      ),
    );
  }
}

class _ExpirationRadioGroup extends StatefulWidget {
  const _ExpirationRadioGroup();

  @override
  State<_ExpirationRadioGroup> createState() => _ExpirationRadioGroupState();
}

class _ExpirationRadioGroupState extends State<_ExpirationRadioGroup> {
  final _kInitialDelay = 1;


  @override
  void initState() {
    super.initState();
    context.read<ExpirationConfigurationCubit>().setDelay(Duration(days: _kInitialDelay));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpirationConfigurationCubit, ExpirationConfigurationState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              context.localization.setExpirationDate,
              style: context.bodyLarge,
            ),
            leading: Radio<FileExpirationType>(
              value: FileExpirationType.delay,
              groupValue: state.expirationType,
              onChanged: (FileExpirationType? value) {
                if (value != null) context.read<ExpirationConfigurationCubit>().setExpirationType(value);
              },
            ),
          ),
          (state.expirationType == FileExpirationType.delay)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 54.0), // TODO set flexible padding
                  child: DropdownMenu<int>(
                    onSelected: (int? value) {
                      if (value != null) context.read<ExpirationConfigurationCubit>().setDelay(Duration(days: value));
                    },
                    initialSelection: _kInitialDelay,
                    trailingIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry<int>(
                        value: 1,
                        label: '1 day',
                      ),
                      DropdownMenuEntry<int>(
                        value: 7,
                        label: '1 week',
                      ),
                      DropdownMenuEntry<int>(
                        value: 30,
                        label: '1 month',
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          ListTile(
            title: Text(
              context.localization.deleteWhenContactDownloadIt,
              style: context.bodyLarge,
            ),
            leading: Radio<FileExpirationType>(
              value: FileExpirationType.atDownload,
              groupValue: state.expirationType,
              onChanged: null,
              /* TODO onChanged: (FileExpirationType? value) {
                if (value != null) context.read<ExpirationConfigurationCubit>().setExpirationType(value);
              },*/
            ),
          ),
        ],
      );
    });
  }
}
