import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sangria_lints/src/rules/no_disabled_tests/no_disabled_tests_visitor.dart';

/// A `no_disabled_tests` rule that raises a warning about disabled tests inspired by no-disabled-tests rule in plugins for Jest and Vitest.
///
/// Test and flutter_test package have a feature that allows you to temporarily mark tests as disabled.
/// This feature is often helpful, however before committing changes we may want to check that all tests are running.
///
/// ### Example
///
/// #### ❌ BAD:
///
/// ```dart
/// void main() {
///   group('test group', () {
///     test('test', () {}, skip: true);
///
///     testWidgets('test widgets', (tester) async {}, skip: true);
///   }, skip: true)
/// }
/// ```
///
/// #### ✅ GOOD:
///
/// ```dart
/// void main() {
///   group('test group', () {
///     test('test', () {});
///
///     testWidgets('test widgets', (tester) async {});
///   })
/// }
/// ```
///

class NoDisabledTestsLintRule extends DartLintRule {
  NoDisabledTestsLintRule()
    : super(
        code: LintCode(
          name: 'no_disabled_tests',
          problemMessage: 'Disallows disabled tests.',
          errorSeverity: ErrorSeverity.WARNING,
        ),
      );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addFunctionExpression((node) {
      final visitor = NoDisabledTestsVisitor(
        reporter: reporter,
        lintCode: code,
      );

      node.body.visitChildren(visitor);
    });
  }
}
