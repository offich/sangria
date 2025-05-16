// ignore_for_file: unintended_html_in_doc_comment

import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sangria_lints/src/rules/use_widget_ref_synchronously/use_widget_ref_synchronously_visitor.dart';

/// A `use_widget_ref_synchronously` rule that discourages the use of
/// WidgetRef across asynchronous gaps within Consumer widgets provided by riverpod.
///
/// In async functions, a widget may have been disposed across asynchronous gaps in a case when the user got back to previous screen. This leads to `Cannot use ref after the widget was disposed called` error.
/// Since widgets can be unmounted before a Future gets resolved, seeing if widgets are mounted is necessary before using WidgetRef.
///
/// [Riverpod](https://riverpod.dev/docs/essentials/faq#i-have-the-error-cannot-use-ref-after-the-widget-was-disposed-whats-wrong) recommends seeing if widgets are mounted to fix the error as well.
///
/// ### Example
///
/// #### ❌ BAD:
///
/// ```dart
/// ElevatedButton(
///   onPressed: () async {
///     await future;
///     ref.read(...); // May throw "Cannot use "ref" after the widget was disposed"
///   }
/// )
/// ```
///
/// #### ✅ GOOD:
///
/// ```dart
/// ElevatedButton(
///   onPressed: () async {
///     await future;
///     if (!context.mounted) return;
///     ref.read(...); // No longer throws
///   }
/// )
/// ```
///

class UseWidgetRefSynchronouslyLintRule extends DartLintRule {
  UseWidgetRefSynchronouslyLintRule()
    : super(
        code: LintCode(
          name: 'use_widget_ref_synchronously',
          problemMessage:
              'Avoid using WidgetRef across asynchronous gaps without seeing if the widget is mounted.',
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
      final hasAsyncKeyword = node.body.keyword?.type == Keyword.ASYNC;
      if (!hasAsyncKeyword) {
        return;
      }

      final visitor = UseWidgetRefSynchronouslyVisitor(
        reporter: reporter,
        lintCode: code,
      );
      node.body.visitChildren(visitor);
    });

    context.registry.addMethodDeclaration((node) {
      final hasAsyncKeyword = node.body.keyword?.type == Keyword.ASYNC;
      if (!hasAsyncKeyword) {
        return;
      }

      final visitor = UseWidgetRefSynchronouslyVisitor(
        reporter: reporter,
        lintCode: code,
      );
      node.body.visitChildren(visitor);
    });
  }
}
