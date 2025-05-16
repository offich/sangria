import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sangria_lints/src/rules/use_widget_ref_synchronously/use_widget_ref_synchronous_util.dart';

class UseWidgetRefSynchronouslyVisitor extends RecursiveAstVisitor<void> {
  bool hasEarlyReturn = false;
  bool wrappedWithMounted = false;
  bool wrappedWithNotMounted = false;

  final ErrorReporter reporter;
  final LintCode lintCode;

  UseWidgetRefSynchronouslyVisitor({
    required this.reporter,
    required this.lintCode,
  });

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final target = node.realTarget;
    if (target?.staticType?.getDisplayString() != 'WidgetRef' ||
        ![
          'read',
          'watch',
          'listen',
          'refresh',
        ].contains(node.methodName.name)) {
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

  @override
  void visitIfStatement(IfStatement node) {
    final condition = node.expression;

    if (condition is PrefixExpression &&
        condition.operator.lexeme == '!' &&
        condition.operand is PrefixedIdentifier) {
      final operand = condition.operand;
      wrappedWithNotMounted = isContextMounted(operand);
      hasEarlyReturn = isEarlyReturn(node.thenStatement);
      node.thenStatement.visitChildren(this);
      wrappedWithNotMounted = false;
    } else if (isContextMounted(condition)) {
      wrappedWithMounted = true;
      node.thenStatement.visitChildren(this);
      wrappedWithMounted = false;
    } else {
      super.visitIfStatement(node);
    }
  }
}
