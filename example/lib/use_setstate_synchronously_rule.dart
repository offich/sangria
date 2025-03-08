import 'package:flutter/material.dart';

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
      displayText = 'displayText-1';
    });

    // invocation with not mounted wrapped
    if (!mounted) {
      // expect_lint: use_setstate_synchronously
      setState(() {
        displayText = 'displayText-1';
      });
    }

    // invocation with not mounted condition and true condition combined
    final trueCondition = true;
    if (!mounted && trueCondition) {
      // expect_lint: use_setstate_synchronously
      setState(() {
        displayText = 'displayText-1';
      });
    }

    // invocation in nested condition
    if (trueCondition) {
      if (!mounted) {
        // expect_lint: use_setstate_synchronously
        setState(() {
          displayText = 'displayText-1';
        });
      }
    }

    // invocation in combined condition
    if (mounted && trueCondition) {
      setState(() {
        displayText = 'displayText5';
      });
    }

    // invocation with mounted wrapped
    if (mounted) {
      setState(() {
        displayText = 'displayText';
      });
    }

    // consecutive invocation with mounted wrapped
    if (mounted) {
      setState(() {
        displayText = 'displayText2';
      });
    }

    // invocation before early returned by not mounted
    if (!mounted) return;
    setState(() {
      displayText = 'displayText3';
    });

    // invocation after early returned by not mounted
    if (mounted) {
      setState(() {
        displayText = 'displayText4';
      });
    }

    // invocation in switch statement
    final matched = 'matched';
    switch (matched) {
      case 'matched':
        if (!mounted) {
          // expect_lint: use_setstate_synchronously
          setState(() {
            displayText = 'displayText5';
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
              displayText = 'displayText-1';
            });

            // invocation with not mounted wrapped
            if (!mounted) {
              // expect_lint: use_setstate_synchronously
              setState(() {
                displayText = 'displayText-1';
              });
            }

            // invocation with not mounted condition and true condition combined
            final trueCondition = true;
            if (!mounted && trueCondition) {
              // expect_lint: use_setstate_synchronously
              setState(() {
                displayText = 'displayText-1';
              });
            }

            // invocation in nested condition
            if (trueCondition) {
              if (!mounted) {
                // expect_lint: use_setstate_synchronously
                setState(() {
                  displayText = 'displayText-1';
                });
              }
            }

            // invocation in combined condition
            if (mounted && trueCondition) {
              setState(() {
                displayText = 'displayText5';
              });
            }

            // invocation with mounted wrapped
            if (mounted) {
              setState(() {
                displayText = 'displayText';
              });
            }

            // consecutive invocation with mounted wrapped
            if (mounted) {
              setState(() {
                displayText = 'displayText2';
              });
            }

            // invocation before early returned by not mounted
            if (!mounted) return;
            setState(() {
              displayText = 'displayText3';
            });

            // invocation after early returned by not mounted
            if (mounted) {
              setState(() {
                displayText = 'displayText4';
              });
            }

            // invocation in switch statement
            final matched = 'matched';
            switch (matched) {
              case 'matched':
                if (!mounted) {
                  // expect_lint: use_setstate_synchronously
                  setState(() {
                    displayText = 'displayText5';
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
