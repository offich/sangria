# Sangria Lints

Custom lints wanted for personal developments.

## Table of content

- [Table of content](#table-of-content)
- [Getting started](#getting-started)
  - [Add sangria\_lints](#add-sangria_lints)
  - [Enable custom\_lint](#enable-custom_lint)
  - [Disabling lint rules](#disabling-lint-rules)
- [All custom-lint rules in sangria\_lints](#all-custom-lint-rules-in-sangria_lints)
  - [use\_setstate\_synchronously](#use_setstate_synchronously)
  - [avoid\_empty\_container](#avoid_empty_container)
  - [no\_disabled\_tests](#no_disabled_tests)

## Getting started

### Add Sangria_lints

Add sangria_lints to your `pubspec.yaml`:

```yaml
dev_dependencies:
  sangria_lints:
```

### Enable custom_lint

sangria_lints comes bundled with its own rules using custom_lints.

- Add both sangria_lints and custom_lint to your `pubspec.yaml`:

  ```yaml
  dev_dependencies:
    sangria_lints:
    custom_lint: # <- add this
  ```

- Enable `custom_lint`'s plugin in your `analysis_options.yaml`:

  ```yaml
  analyzer:
    plugins:
      - sangria_lints
  ```

### Disabling lint rules

By default when installing sangria_lints, all the lints will be enabled.
To change this, you have a few options.

```yaml
analyzer:
  plugins:
    - custom_lint

custom_lint:
  rules:
    # Explicitly disable one custom-lint rule.
    - use_setstate_synchronously: false
```

## All custom-lint rules in sangria_lints

### use_setstate_synchronously

A `use_setstate_synchronously` rule that discourages the use of setState across asynchronous gaps within subclasses of State.

In async functions, the state of a widget may have been disposed across asynchronous gaps in a case when the user moves to a different screen. This leads to `setState() called after dispose()` error.
Since widgets can be unmounted before a Future gets resolved, seeing if widgets are mounted is necessary before calling setState.

#### ❌ BAD

```dart
class _MyWidgetState extends State<MyWidget> {
  String message;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () async {
        String fromSharedPreference = await getFromSharedPreference();
          // LINT: Avoid calling 'setState' across asynchronous gaps without seeing if the widget is mounted.
          setState(() {
            message = fromSharedPreference;
          });
        }
      },
      child: Text(message),
    );
  }
}
```

#### ✅ GOOD

```dart
class _MyWidgetState extends State<MyWidget> {
  String message;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () async {
        String fromSharedPreference = await getFromSharedPreference();
        if (mounted) {
          setState(() {
            message = fromSharedPreference;
          });
        }
      },
      child: Text(message),
    );
  }
}
```

### avoid_empty_container

A `avoid_empty_container` rule that discourages the use of empty container.

Since `Container` generates many properties like padding, margin, decoration, and constraints, it is perfered to use `SizedBox` instead.

#### ❌ BAD

```dart
class CustomText extends StatelessWidget {
  bool canDisplay;

  @override
    Widget build(BuildContext context) {
      return canDisplay ? Text('canDisplay') : Container();
    }
  }
```

#### ✅ GOOD

```dart
class CustomText extends StatelessWidget {
  bool canDisplay;

  @override
    Widget build(BuildContext context) {
      return canDisplay ? Text('canDisplay') : SizedBox.shrink();
    }
  }
```

### no_disabled_tests

A `no_disabled_tests` rule that raises a warning about disabled tests inspired by no-disabled-tests rule in plugins for Jest and Vitest.

Test and flutter_test package have a feature that allows you to temporarily mark tests as disabled.
This feature is often helpful, however before committing changes we may want to check that all tests are running.

#### ❌ BAD

```dart
void main() {
  group('test group', () {
    test('test', () {}, skip: true);

    testWidgets('test widgets', (tester) async {}, skip: true);
  }, skip: true)
}
```

#### ✅ GOOD

```dart
void main() {
  group('test group', () {
    test('test', () {});

    testWidgets('test widgets', (tester) async {});
  })
}
```
