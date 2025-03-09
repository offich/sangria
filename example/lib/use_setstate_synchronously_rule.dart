import 'dart:math';

import 'package:flutter/material.dart';

String generateRandomString() {
  const String charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  return charset[Random.secure().nextInt(charset.length)];
}

class UseSetstateSynchronouslyRuleWidget extends StatefulWidget {
  const UseSetstateSynchronouslyRuleWidget({super.key});

  @override
  _UseSetstateSynchronouslyRuleWidgetState createState() =>
      _UseSetstateSynchronouslyRuleWidgetState();
}

class _UseSetstateSynchronouslyRuleWidgetState
    extends State<UseSetstateSynchronouslyRuleWidget> {
  String displayText = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> setStateAsynchronously() async {
    // simple invocation without mounted wrapped
    // expect_lint: use_setstate_synchronously
    setState(() {
      displayText = generateRandomString();
    });

    // invocation with not mounted wrapped
    if (!mounted) {
      // expect_lint: use_setstate_synchronously
      setState(() {
        displayText = generateRandomString();
      });
    }

    // invocation with not mounted condition and true condition combined
    final trueCondition = true;
    if (!mounted && trueCondition) {
      // expect_lint: use_setstate_synchronously
      setState(() {
        displayText = generateRandomString();
      });
    }

    // invocation with not mounted condition or true condition combined
    if (!mounted || trueCondition) {
      // expect_lint: use_setstate_synchronously
      setState(() {
        displayText = generateRandomString();
      });
    }

    // invocation in nested condition
    if (trueCondition) {
      if (!mounted) {
        // expect_lint: use_setstate_synchronously
        setState(() {
          displayText = generateRandomString();
        });
      }
    }

    // invocation in combined condition
    if (mounted && trueCondition) {
      setState(() {
        displayText = generateRandomString();
      });
    }

    // invocation with mounted wrapped
    if (mounted) {
      setState(() {
        displayText = generateRandomString();
      });
    }

    // consecutive invocation with mounted wrapped
    if (mounted) {
      setState(() {
        displayText = generateRandomString();
      });
    }

    // invocation before early returned by not mounted
    if (!mounted) return;
    setState(() {
      displayText = generateRandomString();
    });

    // invocation after early returned by not mounted
    if (mounted) {
      setState(() {
        displayText = generateRandomString();
      });
    }

    // invocation in switch statement
    final matched = 'matched';
    switch (matched) {
      case 'matched':
        if (!mounted) {
          // expect_lint: use_setstate_synchronously
          setState(() {
            displayText = generateRandomString();
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async => await setStateAsynchronously(),
          child: Text('addMethodDeclaration'),
        ),
        GestureDetector(
          onTap: () async {
            // simple invocation without mounted wrapped
            // expect_lint: use_setstate_synchronously
            setState(() {
              displayText = generateRandomString();
            });

            // invocation with not mounted wrapped
            if (!mounted) {
              // expect_lint: use_setstate_synchronously
              setState(() {
                displayText = generateRandomString();
              });
            }

            // invocation with not mounted condition and true condition combined
            final trueCondition = true;
            if (!mounted && trueCondition) {
              // expect_lint: use_setstate_synchronously
              setState(() {
                displayText = generateRandomString();
              });
            }

            // invocation with not mounted condition or true condition combined
            if (!mounted || trueCondition) {
              // expect_lint: use_setstate_synchronously
              setState(() {
                displayText = generateRandomString();
              });
            }

            // invocation in nested condition
            if (trueCondition) {
              if (!mounted) {
                // expect_lint: use_setstate_synchronously
                setState(() {
                  displayText = generateRandomString();
                });
              }
            }

            // invocation in combined condition
            if (mounted && trueCondition) {
              setState(() {
                displayText = generateRandomString();
              });
            }

            // invocation with mounted wrapped
            if (mounted) {
              setState(() {
                displayText = generateRandomString();
              });
            }

            // consecutive invocation with mounted wrapped
            if (mounted) {
              setState(() {
                displayText = generateRandomString();
              });
            }

            // invocation before early returned by not mounted
            if (!mounted) return;
            setState(() {
              displayText = generateRandomString();
            });

            // invocation after early returned by not mounted
            if (mounted) {
              setState(() {
                displayText = generateRandomString();
              });
            }

            // invocation in switch statement
            final matched = 'matched';
            switch (matched) {
              case 'matched':
                if (!mounted) {
                  // expect_lint: use_setstate_synchronously
                  setState(() {
                    displayText = generateRandomString();
                  });
                }
            }
          },
          child: Text('addFunctionExpression'),
        ),
      ],
    );
  }
}
