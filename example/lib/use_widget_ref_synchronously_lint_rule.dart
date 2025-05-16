import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // expect_lint: use_widget_ref_synchronously
        final state = ref.watch(asyncStateCounterNotifierProvider);
        state.isOdd;

        if (context.mounted) {
          final state = ref.watch(asyncStateCounterNotifierProvider);
          state.isEven;
        }
      });

      return;
    }, []);

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

class StatefulUseWidgetRefSynchronouslyLintRule
    extends StatefulHookConsumerWidget {
  const StatefulUseWidgetRefSynchronouslyLintRule({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _StatefulUseWidgetRefSynchronouslyLintRuleState();
  }
}

class _StatefulUseWidgetRefSynchronouslyLintRuleState
    extends ConsumerState<StatefulUseWidgetRefSynchronouslyLintRule> {
  Future<void> incrementCounterWrapper(
    BuildContext context,
    WidgetRef ref,
  ) async {
    // expect_lint: use_widget_ref_synchronously
    await ref
        .read(asyncStateCounterNotifierProvider.notifier)
        .incrementCounter();

    if (mounted) {
      await ref
          .read(asyncStateCounterNotifierProvider.notifier)
          .incrementCounter();
    }

    if (!mounted) {
      // expect_lint: use_widget_ref_synchronously
      await ref
          .read(asyncStateCounterNotifierProvider.notifier)
          .incrementCounter();
      return;
    }

    if (!mounted) {
      return;
    }

    await ref
        .read(asyncStateCounterNotifierProvider.notifier)
        .incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    final counter = ref.watch(asyncStateCounterNotifierProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // expect_lint: use_widget_ref_synchronously
        final state = ref.watch(asyncStateCounterNotifierProvider);
        state.isOdd;

        if (mounted) {
          final state = ref.watch(asyncStateCounterNotifierProvider);
          state.isEven;
        }
      });

      return;
    }, []);

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

            if (mounted) {
              await ref
                  .read(asyncStateCounterNotifierProvider.notifier)
                  .incrementCounter();
            }

            if (!mounted) {
              // expect_lint: use_widget_ref_synchronously
              await ref
                  .read(asyncStateCounterNotifierProvider.notifier)
                  .incrementCounter();
              return;
            }

            if (!mounted) {
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

  Future<int> getCounter() {
    return Future.delayed(const Duration(seconds: 1), () => state);
  }
}
