// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('enabled test group', () {
    test('enabled test', () {});
    test('enabled test with skip false option', () {}, skip: false);

    testWidgets('enabled test widgets', (tester) async {});
    testWidgets(
      'enabled test widgets with skip false option',
      (tester) async {},
      skip: false,
    );
  });

  // expect_lint: no_disabled_tests
  group('disabled test group', () {
    // expect_lint: no_disabled_tests
    test('disabled test', () {}, skip: true);

    // expect_lint: no_disabled_tests
    testWidgets('disabled test widgets', (tester) async {}, skip: true);
  }, skip: true);
}
