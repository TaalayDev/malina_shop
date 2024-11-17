import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/assets.dart';

enum AuthMode {
  signIn,
  signUp,
  forgotPassword,
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;
  AuthMode _mode = AuthMode.signIn;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _mode = _mode == AuthMode.signIn ? AuthMode.signUp : AuthMode.signIn;
      _formKey.currentState?.reset();
    });
  }

  void _forgotPassword() {
    setState(() => _mode = AuthMode.forgotPassword);
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Implement auth logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _mode == AuthMode.forgotPassword
                ? 'Инструкции по восстановлению отправлены'
                : 'Успешная авторизация',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  Colors.white,
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),

                  // Logo
                  Center(
                    child: Image.asset(
                      Assets.images.logoWithText,
                      height: 80,
                    )
                        .animate()
                        .fadeIn(duration: 1000.ms)
                        .scale(delay: 200.ms)
                        .then()
                        .shimmer(
                          duration: 2000.ms,
                          color: Colors.white.withOpacity(0.2),
                        ),
                  ),

                  const SizedBox(height: 48),

                  // Title
                  Text(
                    _mode == AuthMode.signIn
                        ? 'Добро пожаловать!'
                        : _mode == AuthMode.signUp
                            ? 'Создать аккаунт'
                            : 'Восстановление пароля',
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: -0.2, end: 0),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    _mode == AuthMode.signIn
                        ? 'Войдите в ваш аккаунт'
                        : _mode == AuthMode.signUp
                            ? 'Заполните данные для регистрации'
                            : 'Введите email для восстановления',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 200.ms)
                      .slideY(begin: -0.2, end: 0),

                  const SizedBox(height: 32),

                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Name field (only for sign up)
                        if (_mode == AuthMode.signUp)
                          _buildTextField(
                            controller: _nameController,
                            label: 'Имя',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Пожалуйста, введите имя';
                              }
                              return null;
                            },
                          )
                              .animate()
                              .fadeIn(delay: 400.ms)
                              .slideX(begin: -0.2, end: 0),

                        if (_mode == AuthMode.signUp)
                          const SizedBox(height: 16),

                        // Email field
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите email';
                            }
                            if (!value.contains('@')) {
                              return 'Пожалуйста, введите корректный email';
                            }
                            return null;
                          },
                        )
                            .animate()
                            .fadeIn(delay: 600.ms)
                            .slideX(begin: -0.2, end: 0),

                        if (_mode != AuthMode.forgotPassword) ...[
                          const SizedBox(height: 16),

                          // Password field
                          _buildTextField(
                            controller: _passwordController,
                            label: 'Пароль',
                            icon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Пожалуйста, введите пароль';
                              }
                              if (value.length < 6) {
                                return 'Пароль должен быть не менее 6 символов';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 800.ms)
                              .slideX(begin: -0.2, end: 0),
                        ],

                        const SizedBox(height: 24),

                        // Forgot password button
                        if (_mode == AuthMode.signIn)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: _forgotPassword,
                              child: const Text('Забыли пароль?'),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 1000.ms)
                              .slideX(begin: 0.2, end: 0),

                        const SizedBox(height: 32),

                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _mode == AuthMode.signIn
                                  ? 'Войти'
                                  : _mode == AuthMode.signUp
                                      ? 'Зарегистрироваться'
                                      : 'Отправить',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 1200.ms)
                            .slideY(begin: 0.2, end: 0),

                        const SizedBox(height: 24),

                        // Toggle auth mode button
                        if (_mode != AuthMode.forgotPassword)
                          TextButton(
                            onPressed: _toggleAuthMode,
                            child: Text.rich(
                              TextSpan(
                                text: _mode == AuthMode.signIn
                                    ? 'Нет аккаунта? '
                                    : 'Уже есть аккаунт? ',
                                children: [
                                  TextSpan(
                                    text: _mode == AuthMode.signIn
                                        ? 'Создать'
                                        : 'Войти',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 1400.ms)
                              .slideY(begin: 0.2, end: 0),

                        if (_mode == AuthMode.forgotPassword)
                          TextButton(
                            onPressed: () =>
                                setState(() => _mode = AuthMode.signIn),
                            child: const Text('Вернуться к входу'),
                          )
                              .animate()
                              .fadeIn(delay: 1400.ms)
                              .slideY(begin: 0.2, end: 0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
