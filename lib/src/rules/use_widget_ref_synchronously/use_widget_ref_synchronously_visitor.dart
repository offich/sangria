import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:sangria_lints/src/rules/use_widget_ref_synchronously/use_widget_ref_synchronous_util.dart';

class UseWidgetRefSynchronouslyVisitor extends RecursiveAstVisitor<void> {
  final List<MethodInvocation> refInvocations = [];
  final List<IfStatement> earlyReturns = [];

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final target = node.realTarget;
    if (target?.staticType?.getDisplayString() == 'WidgetRef' &&
        ['read', 'watch', 'listen', 'refresh'].contains(node.methodName.name)) {
      refInvocations.add(node);
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

      if (isContextMounted(operand) && isEarlyReturn(node.thenStatement)) {
        earlyReturns.add(node);
      }
    }

    super.visitIfStatement(node);
  }
}
