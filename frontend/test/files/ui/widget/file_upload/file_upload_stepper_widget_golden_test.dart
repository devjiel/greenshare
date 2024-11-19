import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:greenshare/files/ui/widgets/file_upload/file_upload_stepper_widget.dart';

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