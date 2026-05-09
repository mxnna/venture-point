import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const routeName = '/sign_up';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasMaxLength => _passwordController.text.length <= 64;
  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(_passwordController.text);
  bool get _hasLowercase => RegExp(r'[a-z]').hasMatch(_passwordController.text);
  bool get _hasDigit => RegExp(r'\d').hasMatch(_passwordController.text);
  bool get _hasSpecialChar =>
      RegExp(r'[!@#\$%\^&*(),.?":{}|<>]').hasMatch(_passwordController.text);
  bool get _isPasswordValid =>
      _hasMinLength &&
      _hasMaxLength &&
      _hasUppercase &&
      _hasLowercase &&
      _hasDigit &&
      _hasSpecialChar;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {});
    });
    _confirmPasswordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    if (_formKey.currentState!.validate()) {
      if (!_hasMinLength ||
          !_hasMaxLength ||
          !_hasUppercase ||
          !_hasLowercase ||
          !_hasDigit ||
          !_hasSpecialChar) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Let\'s get you started on your next adventure.'),
          ),
        );
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
        return;
      }
      context.read<AuthBloc>().add(
        AuthSignUpWithEmailRequested(
          _emailController.text.trim(),
          _passwordController.text,
        ),
      );
    }
  }

  Widget _buildRequirementRow(String text, bool fulfilled) {
    return Row(
      children: [
        Icon(
          fulfilled ? Icons.check_circle : Icons.radio_button_unchecked,
          color: fulfilled ? Colors.green : Colors.grey,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: fulfilled ? Colors.black87 : Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }
          if (state is AuthSignUpSuccess) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Account created successfully. Please log in with your new credentials.',
                ),
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              LoginPage.routeName,
              (route) => false,
            );
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 64,
                      width: 64,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                            Text(
                              'Create your account',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Let\'s get you started on your next adventure.',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 26),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(CupertinoIcons.mail),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 16,
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(
                                  r'^[^@]+@[^@]+\.[^@]+',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(CupertinoIcons.lock),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 16,
                                ),
                              ),
                              obscureText: true,
                              onChanged: (value) => setState(() {}),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (!_hasMinLength || !_hasMaxLength) {
                                  return 'Password must be 8-64 characters long';
                                }
                                if (!_hasUppercase) {
                                  return 'Password must contain an uppercase letter';
                                }
                                if (!_hasLowercase) {
                                  return 'Password must contain a lowercase letter';
                                }
                                if (!_hasDigit) {
                                  return 'Password must contain a number';
                                }
                                if (!_hasSpecialChar) {
                                  return 'Password must contain a special character';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Password requirements',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Your password must include:',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildRequirementRow(
                                    '8-64 characters',
                                    _hasMinLength && _hasMaxLength,
                                  ),
                                  const SizedBox(height: 6),
                                  _buildRequirementRow(
                                    'Uppercase letter (A-Z)',
                                    _hasUppercase,
                                  ),
                                  const SizedBox(height: 6),
                                  _buildRequirementRow(
                                    'Lowercase letter (a-z)',
                                    _hasLowercase,
                                  ),
                                  const SizedBox(height: 6),
                                  _buildRequirementRow(
                                    'Number (0-9)',
                                    _hasDigit,
                                  ),
                                  const SizedBox(height: 6),
                                  _buildRequirementRow(
                                    'Special character (!@#\$%...)',
                                    _hasSpecialChar,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: const Icon(CupertinoIcons.lock),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 16,
                                ),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 22),
                            ElevatedButton(
                              onPressed: (_isLoading || !_isPasswordValid)
                                  ? null
                                  : _onSignUpPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.textLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.2,
                                      ),
                                    )
                                  : const Text('Sign up'),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginPage(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    textStyle: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  child: const Text('Log in'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
