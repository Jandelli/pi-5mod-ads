import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../cubits/auth.dart';
import '../../models/auth/user.dart';
import '../../helpers/auth_error_handler.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback? onBackToLogin;

  const RegistrationPage({
    super.key,
    this.onBackToLogin,
  });

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _displayNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegistration() {
    if (_formKey.currentState?.validate() ?? false) {
      final credentials = RegistrationCredentials(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _displayNameController.text.trim().isEmpty
            ? null
            : _displayNameController.text.trim(),
      );

      context.read<AuthBloc>().add(AuthRegisterRequested(credentials));
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, digite seu e-mail';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Por favor, digite um endereço de e-mail válido';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite uma senha';
    }

    if (value.length < 8) {
      return 'A senha deve ter pelo menos 8 caracteres';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, confirme sua senha';
    }

    if (value != _passwordController.text) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, digite um nome de usuário';
    }

    final username = value.trim();
    if (username.length < 3) {
      return 'O nome de usuário deve ter pelo menos 3 caracteres';
    }

    if (username.length > 30) {
      return 'O nome de usuário deve ter no máximo 30 caracteres';
    }

    // Enhanced username validation
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      return 'Use apenas letras, números e sublinhados';
    }

    return null;
  }

  String? _validateDisplayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Campo opcional
    }

    final displayName = value.trim();
    if (displayName.length < 2) {
      return 'O nome de exibição deve ter pelo menos 2 caracteres';
    }

    if (displayName.length > 50) {
      return 'O nome de exibição deve ter no máximo 50 caracteres';
    }

    return null;
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
            // Show success message for successful registration
            AuthErrorHandler.showSuccessSnackbar(
              context,
              'Bem-vindo ${state.user.name}! Registro realizado com sucesso.',
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
                                PhosphorIconsLight.userPlus,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Criar Conta',
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
                              'Junte-se ao Momentum hoje',
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
                          key: const ValueKey('registration_username_field'),
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Usuário *',
                            prefixIcon:
                                const PhosphorIcon(PhosphorIconsLight.user),
                            border: const OutlineInputBorder(),
                            helperText:
                                'Usado para fazer login (3-30 caracteres)',
                            errorMaxLines: 2,
                          ),
                          validator: _validateUsername,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            // Real-time validation feedback
                            if (value.isNotEmpty &&
                                _formKey.currentState != null) {
                              _formKey.currentState!.validate();
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email Field
                        TextFormField(
                          key: const ValueKey('registration_email_field'),
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email *',
                            prefixIcon:
                                const PhosphorIcon(PhosphorIconsLight.envelope),
                            border: const OutlineInputBorder(),
                            helperText: 'Será usado para recuperação de senha',
                            errorMaxLines: 2,
                          ),
                          validator: _validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            // Real-time validation feedback
                            if (value.isNotEmpty &&
                                _formKey.currentState != null) {
                              _formKey.currentState!.validate();
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Display Name Field
                        TextFormField(
                          key: const ValueKey('registration_displayname_field'),
                          controller: _displayNameController,
                          decoration: InputDecoration(
                            labelText: 'Nome de Exibição',
                            prefixIcon:
                                const PhosphorIcon(PhosphorIconsLight.user),
                            border: const OutlineInputBorder(),
                            helperText: 'Como você quer ser chamado (opcional)',
                            errorMaxLines: 2,
                          ),
                          validator: _validateDisplayName,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            // Real-time validation feedback
                            if (value.isNotEmpty &&
                                _formKey.currentState != null) {
                              _formKey.currentState!.validate();
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        TextFormField(
                          key: const ValueKey('registration_password_field'),
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Senha *',
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
                            helperText: 'Mínimo de 8 caracteres',
                            errorMaxLines: 2,
                          ),
                          validator: _validatePassword,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            // Real-time validation feedback
                            if (value.isNotEmpty &&
                                _formKey.currentState != null) {
                              _formKey.currentState!.validate();
                            }
                            // Also validate confirm password if it has content
                            if (_confirmPasswordController.text.isNotEmpty) {
                              _formKey.currentState!.validate();
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password Field
                        TextFormField(
                          key: const ValueKey(
                              'registration_confirm_password_field'),
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Confirmar Senha *',
                            prefixIcon:
                                const PhosphorIcon(PhosphorIconsLight.lockKey),
                            suffixIcon: IconButton(
                              icon: PhosphorIcon(
                                _isConfirmPasswordVisible
                                    ? PhosphorIconsLight.eyeSlash
                                    : PhosphorIconsLight.eye,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                              tooltip: _isConfirmPasswordVisible
                                  ? 'Ocultar senha'
                                  : 'Mostrar senha',
                            ),
                            border: const OutlineInputBorder(),
                            helperText: 'Digite a senha novamente',
                            errorMaxLines: 2,
                          ),
                          validator: _validateConfirmPassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleRegistration(),
                          onChanged: (value) {
                            // Real-time validation feedback
                            if (value.isNotEmpty &&
                                _formKey.currentState != null) {
                              _formKey.currentState!.validate();
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        // Registration Button - Enhanced with better loading state
                        BlocBuilder<AuthBloc, AuthState>(
                          buildWhen: (previous, current) =>
                              previous.runtimeType != current.runtimeType,
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;

                            return ElevatedButton(
                              onPressed: isLoading ? null : _handleRegistration,
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
                                          'Criando conta...',
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
                                      'Criar Conta',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Back to Login
                        TextButton(
                          onPressed: widget.onBackToLogin,
                          child: const Text('Já tem uma conta? Entre aqui'),
                        ),

                        // Required fields notice
                        const SizedBox(height: 8),
                        Text(
                          '* Campos obrigatórios',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                          textAlign: TextAlign.center,
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
