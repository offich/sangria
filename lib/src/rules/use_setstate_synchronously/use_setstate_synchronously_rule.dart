// ignore_for_file: unintended_html_in_doc_comment

import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:sangria_lints/src/rules/use_setstate_synchronously/use_setstate_synchronously_visitor.dart';

/// A `use_setstate_synchronously` rule that discourages the use of
/// setState across asynchronous gaps within subclasses of State.
///
/// In async functions, the state of a widget may have been disposed across asynchronous gaps in a case when the user got back to previous screen. This leads to `setState() called after dispose()` error.
/// Since widgets can be unmounted before a Future gets resolved, seeing if widgets are mounted is necessary before calling setState.
///
/// ### Example
///
/// #### ❌ BAD:
///
/// class _MyWidgetState extends State<MyWidget> {
///   String message;
///
///   @override
///   Widget build(BuildContext context) {
///     return Button(
///       onPressed: () async {
///         String fromSharedPreference = await getFromSharedPreference();
///         // LINT: Avoid calling 'setState' across asynchronous gaps without seeing if the widget is mounted.
///         setState(() {
///           message = fromSharedPreference;
///         });
///       },
///       child: Text(message),
///     );
///   }
/// }
/// ```
///
/// #### ✅ GOOD:
///
/// ```dart
/// class _MyWidgetState extends State<MyWidget> {
///   String message;

///   @override
///   Widget build(BuildContext context) {
///     return Button(
///       onPressed: () async {
///         String fromSharedPreference = await getFromSharedPreference();
///         if (mounted) {
///           setState(() {
///             message = fromSharedPreference;
///           });
///         }
///       },
///       child: Text(message),
///     );
///   }
/// }
/// ```
///
///
class UseSetStateSynchronouslyLintRule extends DartLintRule {
  UseSetStateSynchronouslyLintRule()
    : super(
        code: LintCode(
          name: 'use_setstate_synchronously',
          problemMessage:
              'Avoid calling setState across asynchronous gaps without seeing if the widget is mounted.',
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
