import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// A `avoid_empty_container` rule that discourages the use of empty container.
///
/// Since `Container` generates many properties like padding, margin, decoration, and constraints,
/// it is perfered to use `SizedBox` instead.
///
///
/// ### Example
///
/// #### ❌ BAD:
///
/// ```dart
/// class CustomText extends StatelessWidget {
///   bool canDisplay;
///
///   @override
///   Widget build(BuildContext context) {
///     return canDisplay ? Text('canDisplay') : Container();
///   }
/// }
/// ```
///
/// #### ✅ GOOD:
///
/// ```dart
/// class CustomText extends StatelessWidget {
///   bool canDisplay;
///
///   @override
///   Widget build(BuildContext context) {
///     return canDisplay ? Text('canDisplay') : SizedBox.shrink();
///   }
/// }
/// ```
///

class AvoidEmptyContainerLintRule extends DartLintRule {
  AvoidEmptyContainerLintRule()
    : super(
        code: LintCode(
          name: 'avoid_empty_container',
          problemMessage:
              'Avoid an empty Container. Use SizedBox as a performance-friendly option since Container supports additional decoration and constraints, which may cause heavier processing.',
          errorSeverity: ErrorSeverity.WARNING,
        ),
      );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final className = node.staticType?.getDisplayString();
      if (className != 'Container') {
        return;
      }

      final childrenArg =
          node.argumentList.arguments.whereType<NamedExpression>();
      if (childrenArg.isNotEmpty) {
        return;
      }

      reporter.atNode(node, code);
    });
  }
}
