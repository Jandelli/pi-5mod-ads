import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../cubits/auth.dart';
import '../../models/auth/user.dart';
import '../../helpers/auth_error_handler.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onCreateAccount;

  const LoginPage({
    super.key,
    this.onCreateAccount,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final credentials = LoginCredentials(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );

      context.read<AuthBloc>().add(AuthLoginRequested(credentials));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            // Use the enhanced error handler
            AuthErrorHandler.showErrorSnackbar(context, state.message);
          } else if (state is AuthAuthenticated) {
            // Show success message for successful login
            AuthErrorHandler.showSuccessSnackbar(
              context,
              'Bem-vindo de volta, ${state.user.name}!',
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo and App Name
                        Column(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                PhosphorIconsLight.signIn,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Momentum',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Entre na sua conta',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Username Field
                        TextFormField(
                          key: const ValueKey('login_username_field'),
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Usuário',
                            prefixIcon:
                                const PhosphorIcon(PhosphorIconsLight.user),
                            border: const OutlineInputBorder(),
                            errorMaxLines: 2,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, digite seu usuário';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            // Clear validation errors when user starts typing
                            if (value.isNotEmpty &&
                                _formKey.currentState != null) {
                              _formKey.currentState!.validate();
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        TextFormField(
                          key: const ValueKey('login_password_field'),
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon:
                                const PhosphorIcon(PhosphorIconsLight.lock),
                            suffixIcon: IconButton(
                              icon: PhosphorIcon(
                                _isPasswordVisible
                                    ? PhosphorIconsLight.eyeSlash
                                    : PhosphorIconsLight.eye,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              tooltip: _isPasswordVisible
                                  ? 'Ocultar senha'
                                  : 'Mostrar senha',
                            ),
                            border: const OutlineInputBorder(),
                            errorMaxLines: 2,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite sua senha';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleLogin(),
                          onChanged: (value) {
                            // Clear validation errors when user starts typing
                            if (value.isNotEmpty &&
                                _formKey.currentState != null) {
                              _formKey.currentState!.validate();
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Remember Me Checkbox
                        CheckboxListTile(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          title: const Text('Lembrar-me'),
                          subtitle: Text(
                            'Manter-me conectado por 30 dias',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 24),

                        // Login Button - Enhanced with better loading state
                        BlocBuilder<AuthBloc, AuthState>(
                          buildWhen: (previous, current) =>
                              previous.runtimeType != current.runtimeType,
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;

                            return ElevatedButton(
                              onPressed: isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                disabledBackgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.6),
                              ),
                              child: isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Entrando...',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      'Entrar',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Sign Up Button
                        OutlinedButton(
                          onPressed: widget.onCreateAccount,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Criar Nova Conta',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
