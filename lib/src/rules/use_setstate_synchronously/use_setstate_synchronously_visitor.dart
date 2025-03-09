import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class UseSetstateSynchronouslyVisitor extends RecursiveAstVisitor<void> {
  UseSetstateSynchronouslyVisitor({
    required this.reporter,
    required this.lintCode,
  });

  final ErrorReporter reporter;
  final LintCode lintCode;

  bool wrappedWithMounted = false;
  bool wrappedWithNotMounted = false;
  bool hasEarlyReturn = false;

  @override
  void visitIfStatement(node) {
    final expressionStr = node.expression.toString();

    if (expressionStr.contains('!mounted')) {
      wrappedWithNotMounted = true;

      final thenStatement = node.thenStatement;
      hasEarlyReturn = thenStatement is ReturnStatement ||
          (thenStatement is Block &&
              thenStatement.statements.any((s) => s is ReturnStatement));

      node.thenStatement.visitChildren(this);
      wrappedWithNotMounted = false;
    } else if (expressionStr.contains('mounted')) {
      wrappedWithMounted = true;
      node.thenStatement.visitChildren(this);
      wrappedWithMounted = false;
    } else {
      super.visitIfStatement(node);
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.name != 'setState') {
      return super.visitMethodInvocation(node);
    }

    if (hasEarlyReturn) {
      return super.visitMethodInvocation(node);
    }

    if (wrappedWithNotMounted) {
      reporter.atNode(node, lintCode);
      return super.visitMethodInvocation(node);
    }

    if (!wrappedWithMounted) {
      reporter.atNode(node, lintCode);
      return super.visitMethodInvocation(node);
    }

    super.visitMethodInvocation(node);
  }
}
