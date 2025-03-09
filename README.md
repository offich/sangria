## Sangria

Custom lints wanted for personal developments

## All custom-lint rules in sangria lints

### use_setstate_synchronously

A `use_setstate_synchronously` rule that discourages the use of setState across asynchronous gaps within subclasses of State.

In async functions, the state of a widget may have been disposed across asynchronous gaps in a case when the user moves to a different screen. This leads to `setState() called after dispose()` error.
Since widgets can be unmounted before a Future gets resolved, seeing if widgets are mounted is necessary before calling setState.

### Example

#### ❌ BAD:

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
        },
        child: Text(message),
      );
    }
  }
```

#### ✅ GOOD:

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
