import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intentary_pro/features/auth/domain/usecases/login_usecase.dart';


/// Estado de la UI
class AuthState {
  final bool loading;
  final String? error;
  AuthState({this.loading = false, this.error});

  AuthState copyWith({bool? loading, String? error}) {
    return AuthState(
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

/// Notifier que maneja la lógica de login
class AuthViewModel extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  AuthViewModel(this.loginUseCase) : super(AuthState());

  Future<void> login(String username, String password) async {
    state = state.copyWith(loading: true);
    final result = await loginUseCase(LoginParams(
      username: username,
      password: password,
    ));
    result.fold(
          (failure) {
        state = state.copyWith(
          loading: false,
          error: failure.message,
        );
      },
          (user) {
        state = state.copyWith(loading: false);
      },
    );
  }
}
