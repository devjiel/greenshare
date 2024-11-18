import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:greenshare/files/ui/blocs/available_files/available_files_cubit.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/files/ui/models/file_view_model.dart';
import 'package:greenshare/files/ui/widgets/file_list/file_list_widget.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_in_progress_widget.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_stepper_widget.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_helpers.dart';

void main() {

  setUpAll(() async {
    await loadAppFonts();
  });

  group("FileUploadStepperWidget goldens", () {
    testGoldens("Desktop FileUploadStepper widget", (WidgetTester tester) async {

      await tester.pumpWidgetInPhoneMode(
        widget: const Column(
          children: [
            FileUploadStepperWidget(activeStep: 1),
            SizedBox(height: 16),
            FileUploadStepperWidget(activeStep: 2),
            SizedBox(height: 16),
            FileUploadStepperWidget(activeStep: 3),
          ],
        ),
      );
      await tester.pump();
      await screenMatchesGolden(tester, 'desktop_file_upload_stepper_widget');
    });
  });
}