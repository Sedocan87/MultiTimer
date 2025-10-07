// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TimerNotifier)
const timerProvider = TimerNotifierProvider._();

final class TimerNotifierProvider
    extends $NotifierProvider<TimerNotifier, List<TimerModel>> {
  const TimerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timerNotifierHash();

  @$internal
  @override
  TimerNotifier create() => TimerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TimerModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TimerModel>>(value),
    );
  }
}

String _$timerNotifierHash() => r'a8e749187cb69b84149f0c669dcb1dae356b1a4e';

abstract class _$TimerNotifier extends $Notifier<List<TimerModel>> {
  List<TimerModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<TimerModel>, List<TimerModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<TimerModel>, List<TimerModel>>,
              List<TimerModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
