import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sangria/src/rules/use_setstate_synchronously/use_setstate_synchronously_visitor.dart';

class UseSetStateSynchronouslyLintRule extends DartLintRule {
  UseSetStateSynchronouslyLintRule()
    : super(
        code: LintCode(
          name: 'use_setstate_synchronously',
          problemMessage:
              'Avoid calling setState past an await point without checking if the widget is mounted',
          errorSeverity: ErrorSeverity.WARNING,
        ),
      );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodDeclaration((node) {
      final hasAsyncKeyword = node.body.keyword?.type == Keyword.ASYNC;
      if (!hasAsyncKeyword) {
        return;
      }

      final visitor = UseSetstateSynchronouslyVisitor(
        reporter: reporter,
        lintCode: code,
      );
      node.body.visitChildren(visitor);
    });

    context.registry.addFunctionExpression((node) {
      final hasAsyncKeyword = node.body.keyword?.type == Keyword.ASYNC;
      if (!hasAsyncKeyword) {
        return;
      }

      final visitor = UseSetstateSynchronouslyVisitor(
        reporter: reporter,
        lintCode: code,
      );
      node.body.visitChildren(visitor);
    });
  }
}
