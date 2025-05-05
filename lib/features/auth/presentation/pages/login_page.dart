import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intentary_pro/core/services/snackbar_service.dart';

import 'package:intentary_pro/features/auth/di/auth_providers.dart';
import 'package:intentary_pro/features/auth/presentation/viewmodels/auth_viewmodel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (prev, next) {
      if (prev?.loading == true &&
          next.loading == false &&
          next.error == null) {
        context.go('/home');
      }

      if (next.error != null) {
        SnackbarService.show(
          context,
          message: next.error!,
          type: SnackbarType.error,
        );
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Center(
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bienvenido',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Inicia sesión para continuar',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _userCtrl,
                      decoration: const InputDecoration(labelText: 'Usuario'),
                      validator:
                          (v) =>
                              v == null || v.isEmpty
                                  ? 'Ingresa tu usuario'
                                  : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                      validator:
                          (v) =>
                              v == null || v.isEmpty
                                  ? 'Ingresa tu contraseña'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    Consumer(
                      builder: (context, ref, _) {
                        final AuthState authState = ref.watch(
                          authViewModelProvider,
                        );
                        final AuthViewModel authNotifier = ref.read(
                          authViewModelProvider.notifier,
                        );

                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed:
                                    authState.loading
                                        ? null
                                        : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            authNotifier.login(
                                              _userCtrl.text.trim(),
                                              _passCtrl.text.trim(),
                                            );
                                          }
                                        },
                                child:
                                    authState.loading
                                        ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                        : const Text('Login'),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
