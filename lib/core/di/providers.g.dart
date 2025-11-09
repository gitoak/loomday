// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the active application environment.

@ProviderFor(env)
const envProvider = EnvProvider._();

/// Provides the active application environment.

final class EnvProvider
    extends $FunctionalProvider<AppEnvironment, AppEnvironment, AppEnvironment>
    with $Provider<AppEnvironment> {
  /// Provides the active application environment.
  const EnvProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'envProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$envHash();

  @$internal
  @override
  $ProviderElement<AppEnvironment> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppEnvironment create(Ref ref) {
    return env(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppEnvironment value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppEnvironment>(value),
    );
  }
}

String _$envHash() => r'e6e55d039890a22d8fb7153548df9294a0c3eb39';

/// Provides the shared application logger configured for the active environment.

@ProviderFor(logger)
const loggerProvider = LoggerProvider._();

/// Provides the shared application logger configured for the active environment.

final class LoggerProvider
    extends $FunctionalProvider<AppLogger, AppLogger, AppLogger>
    with $Provider<AppLogger> {
  /// Provides the shared application logger configured for the active environment.
  const LoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loggerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loggerHash();

  @$internal
  @override
  $ProviderElement<AppLogger> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppLogger create(Ref ref) {
    return logger(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLogger value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLogger>(value),
    );
  }
}

String _$loggerHash() => r'31580a29f61dad533c95132887bd28d3061f86ba';

/// Provides the locale service that encapsulates locale change logic.

@ProviderFor(localeService)
const localeServiceProvider = LocaleServiceProvider._();

/// Provides the locale service that encapsulates locale change logic.

final class LocaleServiceProvider
    extends $FunctionalProvider<LocaleService, LocaleService, LocaleService>
    with $Provider<LocaleService> {
  /// Provides the locale service that encapsulates locale change logic.
  const LocaleServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeServiceHash();

  @$internal
  @override
  $ProviderElement<LocaleService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocaleService create(Ref ref) {
    return localeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocaleService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocaleService>(value),
    );
  }
}

String _$localeServiceHash() => r'e4a72e2802dfa647dfda17fc5d90dc627b639a05';

/// Controls the currently selected locale for the application.

@ProviderFor(LocaleController)
const localeControllerProvider = LocaleControllerProvider._();

/// Controls the currently selected locale for the application.
final class LocaleControllerProvider
    extends $NotifierProvider<LocaleController, Locale?> {
  /// Controls the currently selected locale for the application.
  const LocaleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeControllerHash();

  @$internal
  @override
  LocaleController create() => LocaleController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$localeControllerHash() => r'94464cc7c98bb0cd6857620412315c966877422e';

/// Controls the currently selected locale for the application.

abstract class _$LocaleController extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale?, Locale?>,
              Locale?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
