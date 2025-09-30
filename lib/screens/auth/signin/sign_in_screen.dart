import 'package:air2money/screens/service/auth_service.dart';
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

  // Helper widget for a simple social button
  Widget _buildSocialButton({
    required VoidCallback? onTap,
    required IconData icon,
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
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(child: Icon(icon, size: 30, color: iconColor)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simplified UI, removing the complex gradient and animations
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title and welcome message
                Text(
                  'Welcome Back',
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 30),

                // Email field
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_rounded),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter your email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password field
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_rounded),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Enter your password';
                    return null;
                  },
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
                          ),
                          const Text('Remember me'),
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

                // // Sign in button
                // CustomButton(
                //   text: 'Sign In',
                //   onPressed: _isLoading ? null : _signIn,
                //   isLoading: _isLoading,
                //   width: double.infinity,
                //   // Use theme colors
                //   backgroundColor: Theme.of(context).primaryColor,
                // ),

                // Sign up button
                CustomButton(
                  text: 'Sign Up',
                  onPressed: _signIn,
                  isLoading: _isLoading,
                  // height: 55,
                  width: 150,
                  borderRadius: 12,
                  backgroundColor: Colors.purpleAccent.shade200,
                ),

                const SizedBox(height: 40),

                // Or continue with
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or continue with',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 24),

                // Social sign in buttons 🚀
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google Button
                    _buildSocialButton(
                      onTap: _isLoading ? null : () => _socialSignIn('Google'),
                      icon: Icons.g_mobiledata_rounded,
                      iconColor: Colors.red.shade600,
                    ),
                    const SizedBox(width: 20),

                    // Facebook Button
                    _buildSocialButton(
                      onTap:
                          _isLoading ? null : () => _socialSignIn('Facebook'),
                      icon: Icons.facebook_rounded,
                      iconColor: Colors.blue.shade800,
                    ),
                    const SizedBox(width: 20),

                    // Apple Button
                    _buildSocialButton(
                      onTap: _isLoading ? null : () => _socialSignIn('Apple'),
                      icon: Icons.apple_rounded,
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
                            color: Theme.of(context).hintColor,
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
