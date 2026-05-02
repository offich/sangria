# PR Review Guideline

Review code for custom lint rules (`custom_lint_builder`) from the following perspectives:

  - Correctness of `LintCode` definition
  - Appropriate AST visitor selection and traversal
  - False positive prevention
  - Error reporting accuracy
  - Performance and memory safety
  - Test coverage

Prioritize **false positives** and **incorrect AST traversal** as the most critical issues — rules that flag valid code or miss violations entirely undermine user trust.

## Background Knowledge

Custom lint rules hook into the Dart analyzer's AST. Each rule registers visitor callbacks via `context.registry`, which are called for every matching node in every analyzed file. Unlike runtime code, lint rules must handle all valid Dart code patterns without crashing or leaking state between files.

---

## Review Checklist

### LintCode Definition

  - [ ] **Naming**
    - [ ] Rule name is snake_case and uniquely identifies the rule
    - [ ] Name matches the key used in `analysis_options.yaml`
    - [ ] `LintCode` is defined as `static const` — a single instance is a **functional requirement**, not convention (multiple instances break `// ignore:` suppression)
  - [ ] **Messages**
    - [ ] `problemMessage` explains the problem, not the solution (concise, user-friendly)
    - [ ] `correctionMessage` provides actionable guidance on how to fix it
  - [ ] **Severity**
    - [ ] Uses `WARNING` for stylistic/best-practice rules — `ERROR` should be reserved for code that is genuinely broken
    - [ ] Severity is consistent with similar rules in the Dart/Flutter ecosystem

### AST Visitor

  - [ ] **Visitor type selection**
    - [ ] `RecursiveAstVisitor` is used when full subtree traversal is needed
    - [ ] Targeted `context.registry.add*` callbacks are used when only specific node types are needed (more efficient than full recursion)
  - [ ] **Node type coverage**
    - [ ] All relevant node types are covered (e.g., both `MethodDeclaration` and `FunctionExpression` when a pattern can appear in either)
    - [ ] Arrow functions, closures, and async constructs are considered
  - [ ] **Visitor state management**
    - [ ] If stateful flags are used (e.g., `wrappedWithMounted`), they are reset after each relevant block
    - [ ] State does not leak between separate file analyses
    - [ ] No shared mutable state between visitor instances

### False Positive Prevention

  - [ ] **Context-aware checks**
    - [ ] Guard conditions are detected and respected (e.g., `if (mounted)`, early `return`)
    - [ ] Parent context is examined when needed (`node.thisOrAncestorOfType<T>()`)
  - [ ] **Type checking**
    - [ ] `staticType?.getDisplayString()` is used for type-safe checks instead of string comparison on names
    - [ ] `staticType` null cases are handled
  - [ ] **No duplicate reports**
    - [ ] The same issue is not reported multiple times for nested structures
    - [ ] `super.visit*()` is not redundantly re-checking already-visited nodes

### Error Reporting

  - [ ] **Correct node selection**
    - [ ] Reports on the most specific relevant node (e.g., method name token, not the full call expression)
    - [ ] `reporter.atNode(node, lintCode)` is used for node-based reporting
  - [ ] **Diagnostic location**
    - [ ] The highlighted range in the editor points to the exact problematic code

### Performance & Memory

  - [ ] **No cached AST references**
    - [ ] AST nodes, elements, and resolved types are **never** stored in fields or static variables — this causes memory leaks and stale references between analyses
    - [ ] All processing happens within the visitor callback and is discarded immediately
  - [ ] **Minimal work in hot paths**
    - [ ] Early returns filter out non-matching nodes before any expensive checks
    - [ ] No I/O or synchronous blocking operations inside visitors

### Rule Registration

  - [ ] Rule is instantiated and included in `getLintRules()` in `lib/sangria_lints.dart`
  - [ ] Rule is exported from `lib/sangria_lints.dart`

### Testing

  - [ ] **Example file added** under `example/lib/` demonstrating the violation
  - [ ] **Both cases are covered**:
    - [ ] Code that SHOULD trigger the lint
    - [ ] Similar code that should NOT trigger the lint (false positive check)
  - [ ] Verified with `cd example && dart run custom_lint`
  - [ ] Edge cases are covered: nested structures, async contexts, arrow functions

---

## Common Pitfalls

  - **Forgetting to register**: Rule is defined but never added to `getLintRules()`
  - **Wrong severity**: Using `ERROR` for stylistic lints breaks user builds
  - **State leakage**: Visitor flag not reset → affects subsequent nodes in the same or different files
  - **Non-const `LintCode`**: Multiple instances break `// ignore:` suppression
  - **Incomplete node coverage**: Only checking `MethodDeclaration` but missing `FunctionExpression` (or vice versa)
  - **String-based type matching**: Using `node.toString()` instead of `staticType?.getDisplayString()` — fragile and format-dependent
  - **Ignoring guard conditions**: Not recognizing that `if (!mounted) return` makes the subsequent code safe

---

## Code Examples

### 1. LintCode must be `static const` (single instance)

```dart
// Bad: multiple instances break // ignore: suppression
LintCode get lintCode => LintCode(name: 'my_rule', ...);

// Good
static const LintCode lintCode = LintCode(name: 'my_rule', ...);
```

### 2. Register for all relevant node types

```dart
// Bad: misses async callbacks defined as FunctionExpression
@override
void run(CustomLintResolver resolver, ErrorReporter reporter,
    CustomLintContext context) {
  context.registry.addMethodDeclaration((node) { ... });
}

// Good: covers both declaration forms
@override
void run(CustomLintResolver resolver, ErrorReporter reporter,
    CustomLintContext context) {
  context.registry.addMethodDeclaration((node) { ... });
  context.registry.addFunctionExpression((node) { ... });
}
```

### 3. Never cache AST nodes

```dart
// Bad: stale reference after re-analysis
class MyRule extends DartLintRule {
  AstNode? _lastVisited; // memory leak + stale across files

  @override
  void run(...) {
    context.registry.addMethodInvocation((node) {
      _lastVisited = node; // never do this
    });
  }
}

// Good: process immediately, hold no reference
context.registry.addMethodInvocation((node) {
  if (_isViolation(node)) {
    reporter.atNode(node, lintCode);
  }
});
```

### 4. Respect guard conditions to avoid false positives

```dart
// Rule: flag async calls after widget unmount

// Should NOT flag (guarded by mounted check)
if (!mounted) return;
await someAsyncCall(); // safe

// Should flag (no guard)
await someAsyncCall(); // after async gap, mounted is not guaranteed
```

### 5. Reset visitor state between scopes

```dart
// Bad: flag leaks across method boundaries
class _MyVisitor extends RecursiveAstVisitor<void> {
  bool _seenAwait = false;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node); // _seenAwait may be true from prev method
  }
}

// Good: reset before entering each new scope
@override
void visitMethodDeclaration(MethodDeclaration node) {
  _seenAwait = false;
  super.visitMethodDeclaration(node);
}
```

---

## Options

  - `--pre-commit`: Pre-commit check mode (stricter review)
  - `--focus=false-positives`: Focus review on false positive risk
