import 'package:analyzer/dart/ast/ast.dart';

bool isContextMounted(Expression expr) {
  if (expr is PrefixedIdentifier) {
    return expr.prefix.name == 'context' && expr.identifier.name == 'mounted';
  }

  return false;
}

bool isMountedCondition(Expression expression) {
  if (expression is SimpleIdentifier) {
    return expression.name == 'mounted';
  }

  return false;
}

bool isAfterEarlyReturn(MethodInvocation node, List<IfStatement> earlyReturns) {
  return earlyReturns.any((earlyReturn) => node.offset > earlyReturn.offset);
}

bool isEarlyReturn(Statement statement) {
  if (statement is ReturnStatement) {
    return true;
  }

  if (statement is Block && statement.statements.isNotEmpty) {
    return isEarlyReturn(statement.statements.first);
  }

  return false;
}
