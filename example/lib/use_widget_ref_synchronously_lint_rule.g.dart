// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'use_widget_ref_synchronously_lint_rule.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AsyncStateCounterNotifier)
final asyncStateCounterProvider = AsyncStateCounterNotifierProvider._();

final class AsyncStateCounterNotifierProvider
    extends $NotifierProvider<AsyncStateCounterNotifier, int> {
  AsyncStateCounterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'asyncStateCounterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$asyncStateCounterNotifierHash();

  @$internal
  @override
  AsyncStateCounterNotifier create() => AsyncStateCounterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$asyncStateCounterNotifierHash() =>
    r'365b25d3156473bad6173c6425546d4b46c395ca';

abstract class _$AsyncStateCounterNotifier extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
