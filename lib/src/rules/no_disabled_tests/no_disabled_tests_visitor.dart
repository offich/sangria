import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class NoDisabledTestsVisitor extends RecursiveAstVisitor<void> {
  NoDisabledTestsVisitor({required this.reporter, required this.lintCode});

  final ErrorReporter reporter;
  final LintCode lintCode;

  @override
  void visitArgumentList(ArgumentList node) {
    final parent = node.parent;
    if (parent is! MethodInvocation) {
      return;
    }

    final methodName = parent.methodName.name;
    if (!['group', 'testWidgets', 'test'].contains(methodName)) {
      return;
    }

    for (final arg in node.arguments) {
      if (arg is! NamedExpression) {
        continue;
      }

      final name = arg.name.label.name;
      if (name != 'skip') {
        continue;
      }

      final expression = arg.expression;
      if (expression is! BooleanLiteral) {
        continue;
      }

      final value = expression.value;
      if (value) {
        reporter.atNode(node, lintCode);
      }
    }

    super.visitArgumentList(node);
  }
}
