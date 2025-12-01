// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Auth ViewModel - Manages authentication state

@ProviderFor(AuthViewModel)
const authViewModelProvider = AuthViewModelProvider._();

/// Auth ViewModel - Manages authentication state
final class AuthViewModelProvider
    extends $NotifierProvider<AuthViewModel, AuthState> {
  /// Auth ViewModel - Manages authentication state
  const AuthViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authViewModelHash();

  @$internal
  @override
  AuthViewModel create() => AuthViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authViewModelHash() => r'6f062d48969fabe61a830f1c7d9c34eb5c716004';

/// Auth ViewModel - Manages authentication state

abstract class _$AuthViewModel extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Password Reset ViewModel

@ProviderFor(PasswordResetViewModel)
const passwordResetViewModelProvider = PasswordResetViewModelProvider._();

/// Password Reset ViewModel
final class PasswordResetViewModelProvider
    extends $NotifierProvider<PasswordResetViewModel, PasswordResetState> {
  /// Password Reset ViewModel
  const PasswordResetViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordResetViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordResetViewModelHash();

  @$internal
  @override
  PasswordResetViewModel create() => PasswordResetViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PasswordResetState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PasswordResetState>(value),
    );
  }
}

String _$passwordResetViewModelHash() =>
    r'13b5821a1b3e5c7187f1cc9ebd93a6498a3138d8';

/// Password Reset ViewModel

abstract class _$PasswordResetViewModel extends $Notifier<PasswordResetState> {
  PasswordResetState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PasswordResetState, PasswordResetState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PasswordResetState, PasswordResetState>,
              PasswordResetState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Password Change ViewModel

@ProviderFor(PasswordChangeViewModel)
const passwordChangeViewModelProvider = PasswordChangeViewModelProvider._();

/// Password Change ViewModel
final class PasswordChangeViewModelProvider
    extends $NotifierProvider<PasswordChangeViewModel, PasswordChangeState> {
  /// Password Change ViewModel
  const PasswordChangeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordChangeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordChangeViewModelHash();

  @$internal
  @override
  PasswordChangeViewModel create() => PasswordChangeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PasswordChangeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PasswordChangeState>(value),
    );
  }
}

String _$passwordChangeViewModelHash() =>
    r'eb66e275b0421364717e6d62363839f36e769325';

/// Password Change ViewModel

abstract class _$PasswordChangeViewModel
    extends $Notifier<PasswordChangeState> {
  PasswordChangeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<PasswordChangeState, PasswordChangeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PasswordChangeState, PasswordChangeState>,
              PasswordChangeState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
