import 'package:air2money/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  void initState() {
    super.initState();
    _handleLogout();
  }

  Future<void> _handleLogout() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    await authService.signOut(); // <-- your logout function

    if (!mounted) return;
    context.go('/signin'); // redirect back to login
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
