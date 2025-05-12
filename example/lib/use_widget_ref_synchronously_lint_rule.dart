import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_widget_ref_synchronously_lint_rule.g.dart';

class UseWidgetRefSynchronouslyLintRule extends HookConsumerWidget {
  const UseWidgetRefSynchronouslyLintRule({super.key});

  Future<void> incrementCounterWrapper(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // expect_lint: use_widget_ref_synchronously
    await ref
        .read(asyncStateCounterNotifierProvider.notifier)
        .incrementCounter();

    if (context.mounted) {
      await ref
          .read(asyncStateCounterNotifierProvider.notifier)
          .incrementCounter();
    }

    if (!context.mounted) {
      // expect_lint: use_widget_ref_synchronously
      await ref
          .read(asyncStateCounterNotifierProvider.notifier)
          .incrementCounter();
      return;
    }

    if (!context.mounted) {
      return;
    }

    await ref
        .read(asyncStateCounterNotifierProvider.notifier)
        .incrementCounter();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(asyncStateCounterNotifierProvider);

    return Column(
      children: [
        Text('counter: $counter'),
        GestureDetector(
          child: Text('increment'),
          onTap: () async {
            // expect_lint: use_widget_ref_synchronously
            await ref
                .read(asyncStateCounterNotifierProvider.notifier)
                .incrementCounter();

            if (context.mounted) {
              await ref
                  .read(asyncStateCounterNotifierProvider.notifier)
                  .incrementCounter();
            }

            if (!context.mounted) {
              // expect_lint: use_widget_ref_synchronously
              await ref
                  .read(asyncStateCounterNotifierProvider.notifier)
                  .incrementCounter();
              return;
            }

            if (!context.mounted) {
              return;
            }

            await ref
                .read(asyncStateCounterNotifierProvider.notifier)
                .incrementCounter();
          },
        ),
      ],
    );
  }
}

@riverpod
class AsyncStateCounterNotifier extends _$AsyncStateCounterNotifier {
  @override
  int build() {
    return 0;
  }

  Future<void> incrementCounter() {
    return Future.delayed(const Duration(seconds: 2), () => state++);
  }
}
