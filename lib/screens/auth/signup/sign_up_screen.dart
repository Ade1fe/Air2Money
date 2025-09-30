import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:flutter/services.dart';

// Assuming the AuthService is two levels up in a 'service' directory
import '../../service/auth_service.dart';
import '../../../consants/image_constants.dart' show ImageConstants;
import '../../../widgets/custom_button.dart' show CustomButton;
import '../../../widgets/custom_textfield.dart' show CustomTextField;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

// Removed: with SingleTickerProviderStateMixin and animation fields/methods
class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    // 1. Validation Checks
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms and Conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Call AuthService via Provider
      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await authService.signUp(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // 3. Handle Navigation/Result
        if (success) {
          // Navigate to home screen on successful sign up
          context.go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign up failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred during sign up.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Updated social button helper to allow 'onTap' to be null for disabling
  Widget _buildSocialButton({
    required VoidCallback? onTap, // <-- Nullable onTap
    required String icon,
    required IconData fallbackIcon,
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
          child: Image.asset(
            icon,
            width: 30,
            height: 30,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                fallbackIcon,
                size: 30,
                color: Colors.purpleAccent.shade400,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo + App name
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
                      "Convert Airtime to Cash Instantly",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Full Name
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Full Name',
                  prefixIcon: const Icon(Icons.person),
                  validator:
                      (value) =>
                          value!.isEmpty ? "Please enter your name" : null,
                ),
                const SizedBox(height: 20),

                // Email
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock),
                  validator:
                      (value) =>
                          value!.length < 6 ? "At least 6 characters" : null,
                ),
                const SizedBox(height: 20),

                // Confirm Password
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock),
                  validator:
                      (value) =>
                          value != _passwordController.text
                              ? "Passwords don’t match"
                              : null,
                ),

                // Terms
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged:
                          (v) => setState(() => _agreeToTerms = v ?? false),
                      activeColor: Colors.purple,
                    ),
                    Expanded(
                      child: Text(
                        "I agree to the Terms & Conditions",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Sign Up Button
                CustomButton(
                  text: "Sign Up",
                  onPressed: _signUp,
                  isLoading: _isLoading,
                  width: double.infinity,
                  borderRadius: 8,
                  backgroundColor: Colors.purple,
                ),

                const SizedBox(height: 24),

                // OR Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),

                const SizedBox(height: 20),

                // Social buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialButton(
                      onTap: () {},
                      icon: 'lib/assets/google.png',
                      fallbackIcon: Icons.g_mobiledata,
                    ),
                    const SizedBox(width: 16),
                    _buildSocialButton(
                      onTap: () {},
                      icon: 'lib/assets/facebook.png',
                      fallbackIcon: Icons.facebook,
                    ),
                    const SizedBox(width: 16),
                    _buildSocialButton(
                      onTap: () {},
                      icon: 'lib/assets/apple.png',
                      fallbackIcon: Icons.apple,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Sign in link
                TextButton(
                  onPressed: () => context.pop(),
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.grey.shade700),
                      children: const [
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
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
