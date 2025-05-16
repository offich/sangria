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
  void visitIfStatement(IfStatement node) {
    final classDecl = node.thisOrAncestorOfType<ClassDeclaration>();
    final superclass = classDecl?.extendsClause?.superclass.name2.toString();
    final condition = node.expression;
    final conditionFunc =
        superclass == 'ConsumerState'
            ? isMountedCondition
            : isContextMountedCondition;

    if (condition is PrefixExpression && condition.operator.lexeme == '!') {
      final operand = condition.operand;
      wrappedWithNotMounted = conditionFunc(operand);
      hasEarlyReturn = isEarlyReturn(node.thenStatement);
      node.thenStatement.visitChildren(this);
      wrappedWithNotMounted = false;
    } else if (conditionFunc(condition)) {
      wrappedWithMounted = true;
      node.thenStatement.visitChildren(this);
      wrappedWithMounted = false;
    } else {
      super.visitIfStatement(node);
    }
  }

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
}
