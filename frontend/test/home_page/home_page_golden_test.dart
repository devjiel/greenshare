import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:greenshare/main.dart';

import '../test_helpers.dart';

void main() {

  setUpAll(() async {
    await loadAppFonts();
  });

  group("HomePage page goldens", () {
    for (var locale in locales) {
      testGoldens("Desktop HomePage page in $locale", (WidgetTester tester) async {
        await tester.pumpWidgetInDesktopMode(
          const HomePage(),
          locale,
        );
        await tester.pump();
        await screenMatchesGolden(tester, 'desktop_home_page_$locale');
      });
    }
  });
}