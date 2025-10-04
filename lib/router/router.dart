import 'package:air2money/screens/airtime/airtime_demo_screen%20.dart';
import 'package:air2money/screens/auth/logout_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:air2money/service/auth_service.dart';
import '../screens/auth/signin/sign_in_screen.dart';
import '../screens/auth/signup/sign_up_screen.dart';
import '../widgets/app_scaffold.dart';
import '../consants/image_constants.dart';
import '../theme/theme.dart';
import '../widgets/custom_button.dart' show CustomButton;
import '../widgets/main_container_screen.dart';

// Router Notifier
class RouterNotifier extends ChangeNotifier {
  bool _shouldRefresh = false;

  void refreshRoutes() {
    _shouldRefresh = true;
    notifyListeners();
    _shouldRefresh = false;
  }
}

// Global navigator key
final rootNavigatorKey = GlobalKey<NavigatorState>();
final routerNotifier = RouterNotifier();

// ✅ Correct factory
GoRouter createRouter(AuthService authService) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final loggedIn = authService.isAuthenticated;
      final loggingIn =
          state.matchedLocation == '/signin' ||
          state.matchedLocation == '/signup';

      // If not logged in → block access to home
      if (!loggedIn && state.matchedLocation == '/home') {
        return '/signin';
      }

      // If logged in → block going back to signin/signup
      if (loggedIn && loggingIn) {
        return '/home';
      }

      return null; // no redirect
    },

    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/find-your-screen',
        name: 'find-your-screen',
        builder: (context, state) => const FindYourScreen(),
      ),
      GoRoute(
        path: '/signin',
        name: 'signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/logout',
        name: 'logout',
        builder: (context, state) => const LogoutScreen(),
      ),

      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainContainerScreen(),
      ),
      GoRoute(
        path: '/airtime',
        name: 'airtime',
        builder: (context, state) => const AirtimeDemoScreen(),
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(child: Text('Page not found: ${state.error}')),
        ),
  );
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.loadUserFromStorage();

    if (auth.isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/find-your-screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      padding: EdgeInsets.zero,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageConstants.logo, width: 200, height: 100),
            Text(
              'Air2Money',
              style: AppTextStyles.getStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextPrimary
                        : Colors.purple.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// "Find Your Screen" (intro screen)
class FindYourScreen extends StatelessWidget {
  const FindYourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageConstants.foodimg, width: 300, height: 300),
            const SizedBox(height: 10),
            Text(
              'Convert Airtime to Cash',
              style: AppTextStyles.subHeading.copyWith(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Convert your Airtel airtime to cash instantly with the best rates.',
              style: AppTextStyles.body.copyWith(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Next',
              backgroundColor: Colors.purpleAccent.shade200,
              width: 150,
              onPressed: () {
                context.go('/signin');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
