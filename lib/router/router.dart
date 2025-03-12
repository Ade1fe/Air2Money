import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/signin/sign_in_screen.dart';
import '../screens/auth/signup/sign_up_screen.dart';
import '../screens/dashboard/home_screen.dart';
import '../widgets/app_scaffold.dart';
import '../consants/image_constants.dart';
import '../theme/theme.dart';
import '../widgets/custom_button.dart' show ButtonType, CustomButton;
import '../widgets/main_container_screen.dart';

// Create a router notifier to handle route changes
class RouterNotifier extends ChangeNotifier {
  // ignore: unused_field
  bool _shouldRefresh = false;

  void refreshRoutes() {
    _shouldRefresh = true;
    notifyListeners();
    _shouldRefresh = false;
  }
}

// Create a global key for the navigator
final rootNavigatorKey = GlobalKey<NavigatorState>();
final routerNotifier = RouterNotifier();

// Create a GoRouter configuration
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,
  refreshListenable: routerNotifier,
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
      path: '/home',
      name: 'home',
      builder: (context, state) => const MainContainerScreen(),
    ),
    // Add other routes as needed
  ],
  // Error handling for routes that don't exist
  errorBuilder:
      (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.deepOrange.shade400,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                'Page Not Found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The page you are looking for doesn\'t exist or has been moved.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
);

// SplashScreen implementation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/find-your-screen');
      }
    });
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
            Image.asset(ImageConstants.logo, width: 200, height: 200),
            const SizedBox(height: 20),
            Text(
              'Air2Money',
              style: AppTextStyles.getStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextPrimary
                        : AppColors.brown,
              ),
            ),
            Text(
              'Convert Airtel to Cash Instantly',
              style: AppTextStyles.body.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
            const SizedBox(height: 20),
            Text(
              'Convert Airtime to Cash',
              style: AppTextStyles.subHeading.copyWith(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
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
              width: 150,
              onPressed: () {
                context.go('/signin');
              },
              type: ButtonType.primary,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
