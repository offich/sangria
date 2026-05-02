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
        .read(asyncStateCounterProvider.notifier)
        .asyncIncrementCounter();

    if (context.mounted) {
      ref
          .read(asyncStateCounterProvider.notifier)
          .syncIncrementCounter();
    }

    if (!context.mounted) {
      // expect_lint: use_widget_ref_synchronously
      ref
          .read(asyncStateCounterProvider.notifier)
          .syncIncrementCounter();
      return;
    }

    if (!context.mounted) {
      return;
    }

    ref.read(asyncStateCounterProvider.notifier).syncIncrementCounter();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(asyncStateCounterProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // expect_lint: use_widget_ref_synchronously
        final state = ref.watch(asyncStateCounterProvider);
        state.isOdd;

        if (context.mounted) {
          final state = ref.watch(asyncStateCounterProvider);
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
                .read(asyncStateCounterProvider.notifier)
                .asyncIncrementCounter();

            if (context.mounted) {
              ref
                  .read(asyncStateCounterProvider.notifier)
                  .syncIncrementCounter();
            }

            if (!context.mounted) {
              // expect_lint: use_widget_ref_synchronously
              ref
                  .read(asyncStateCounterProvider.notifier)
                  .syncIncrementCounter();
              return;
            }

            if (!context.mounted) {
              return;
            }

            ref
                .read(asyncStateCounterProvider.notifier)
                .syncIncrementCounter();
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
        .read(asyncStateCounterProvider.notifier)
        .asyncIncrementCounter();

    if (mounted) {
      ref
          .read(asyncStateCounterProvider.notifier)
          .syncIncrementCounter();
    }

    if (!mounted) {
      // expect_lint: use_widget_ref_synchronously
      ref
          .read(asyncStateCounterProvider.notifier)
          .syncIncrementCounter();
      return;
    }

    if (!mounted) {
      return;
    }

    ref.read(asyncStateCounterProvider.notifier).syncIncrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    final counter = ref.watch(asyncStateCounterProvider);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // expect_lint: use_widget_ref_synchronously
        final state = ref.watch(asyncStateCounterProvider);
        state.isOdd;

        if (mounted) {
          final state = ref.watch(asyncStateCounterProvider);
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
                .read(asyncStateCounterProvider.notifier)
                .asyncIncrementCounter();

            if (mounted) {
              ref
                  .read(asyncStateCounterProvider.notifier)
                  .syncIncrementCounter();
            }

            if (!mounted) {
              // expect_lint: use_widget_ref_synchronously
              ref
                  .read(asyncStateCounterProvider.notifier)
                  .syncIncrementCounter();
              return;
            }

            if (!mounted) {
              return;
            }

            ref
                .read(asyncStateCounterProvider.notifier)
                .syncIncrementCounter();
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

  Future<void> asyncIncrementCounter() {
    return Future.delayed(const Duration(seconds: 2), () => state++);
  }

  void syncIncrementCounter() {
    state++;
  }

  Future<int> getCounter() {
    return Future.delayed(const Duration(seconds: 1), () => state);
  }
}
