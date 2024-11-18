import 'package:flutter/material.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/theme.dart';

class FileUploadStepperWidget extends StatelessWidget {
  const FileUploadStepperWidget({super.key, this.activeStep = 1});

  final int activeStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _FileUploadStepperStepWidget(
          index: 1,
          text: context.localization.upload,
          state: activeStep > 1 ? StepState.done : activeStep == 1 ? StepState.active : StepState.inactive,
        ),
        const SizedBox(width: kDefaultPadding),
        _FileUploadStepperStepWidget(
          index: 2,
          text: context.localization.configureExpiration,
          state: activeStep > 2 ? StepState.done : activeStep > 1 ? StepState.active : StepState.inactive,
        ),
        const SizedBox(width: kDefaultPadding),
        _FileUploadStepperStepWidget(
          index: 3,
          text: context.localization.share,
          state: activeStep > 3 ? StepState.done : activeStep > 2 ? StepState.active : StepState.inactive,
        ),
      ],
    );
  }
}

class _FileUploadStepperStepWidget extends StatelessWidget {
  const _FileUploadStepperStepWidget({required this.index, required this.text, this.state = StepState.inactive});

  final int index;
  final String text;
  final StepState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: (state == StepState.inactive) ? kDarkGreen : kLightGreen,
          child: (state == StepState.done)
              ? const Icon(Icons.check_rounded, size: 12, color: kBlack)
              : Text(
                  index.toString(),
                  style: context.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kBlack,
                  ),
                ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: context.labelLarge?.copyWith(
            color: (state == StepState.inactive) ? kDarkGreen : kLightGreen,
          ),
        ),
      ],
    );
  }
}

enum StepState {
  done,
  active,
  inactive,
}
