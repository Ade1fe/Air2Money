import 'package:air2money/consants/image_constants.dart';
import 'package:air2money/service/auth_service.dart';
import 'package:air2money/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../widgets/custom_button.dart'; // Assuming this is your CustomButton
import '../../../widgets/custom_textfield.dart'; // Assuming this is your CustomTextField

// You can remove all the complex animation mixins and controllers for simplicity
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handle traditional email/password sign in
  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await authService.signIn(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        if (success) {
          context.go('/home');
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign In failed. Check credentials.')),
          );
        }
      }
    }
  }

  // New: Handle social sign in
  void _socialSignIn(String provider) async {
    setState(() => _isLoading = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.signInWithSocial(provider);

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$provider sign in failed. Try again.')),
        );
      }
    }
  }

  Widget _buildSocialButton({
    required VoidCallback? onTap,
    required String? icon, // make icon nullable
    required IconData fallbackIcon,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Center(
          child:
              icon != null
                  ? Image.asset(icon, width: 30, height: 30)
                  : Icon(fallbackIcon, size: 30, color: iconColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simplified UI, removing the complex gradient and animations
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // // Title and welcome message
                // Text(
                //   'Welcome Back',
                //   style: Theme.of(
                //     context,
                //   ).textTheme.displayLarge?.copyWith(fontSize: 28),
                // ),
                // const SizedBox(height: 8),
                // Text(
                //   'Sign in to continue',
                //   style: Theme.of(context).textTheme.bodySmall,
                // ),
                // const SizedBox(height: 30),
                Column(
                  children: [
                    Image.asset(ImageConstants.logo, width: 70, height: 70),
                    const SizedBox(height: 12),
                    const Text(
                      "Air2Money",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Email field
                CustomTextField(
                  controller: _emailController,
                  hint: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email,
                  // prefixIcon: const Icon(Icons.email_rounded),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your email';
                    }
                    return null;
                  },
                  label: 'Email Address',
                ),
                const SizedBox(height: 20),

                // Password field
                CustomTextField(
                  controller: _passwordController,
                  hint: 'Password',
                  obscureText: true,
                  icon: Icons.password,
                  // prefixIcon: const Icon(Icons.lock_rounded),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    }
                    return null;
                  },
                  label: 'Password',
                ),

                // Remember me and forgot password (kept for completeness)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() => _rememberMe = value ?? false);
                            },
                            activeColor: AppColors.primary,
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // TODO: Navigate to forgot password screen
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Sign up button
                CustomButton(
                  text: 'Sign In',
                  onPressed: _signIn,
                  isLoading: _isLoading,
                  // height: 55,
                  width: 150,
                  borderRadius: 12,
                  backgroundColor: AppColors.primary,
                ),

                const SizedBox(height: 40),

                // Or continue with
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or continue with',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),

                const SizedBox(height: 24),

                // Social buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      onTap: _isLoading ? null : () => _socialSignIn('Google'),
                      icon: null,
                      fallbackIcon: Icons.g_mobiledata,
                      iconColor: Colors.red.shade600,
                    ),
                    const SizedBox(width: 16),
                    _buildSocialButton(
                      onTap:
                          _isLoading ? null : () => _socialSignIn('Facebook'),
                      icon: null, // force using Icon instead of asset
                      fallbackIcon: Icons.facebook,
                      iconColor: Colors.blue.shade800,
                    ),

                    const SizedBox(width: 16),
                    _buildSocialButton(
                      onTap: _isLoading ? null : () => _socialSignIn('Apple'),
                      icon: null,
                      fallbackIcon: Icons.apple,
                      iconColor: Colors.black,
                    ),
                  ],
                ),

                // Sign up link
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () => context.push('/signup'),
                        child: Text(
                          'Sign Up',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
