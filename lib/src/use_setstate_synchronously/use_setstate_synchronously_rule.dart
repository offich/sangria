import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class UseSetStateSynchronouslyLintRule extends DartLintRule {
  const UseSetStateSynchronouslyLintRule() : super(code: _code);

  static const _code = LintCode(
    name: 'use-setstate-synchronously',
    problemMessage:
        'Avoid calling setState past an await point without checking if the widget is mounted',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addVariableDeclaration((node) {
      reporter.atNode(node, code);
    });
  }
}
