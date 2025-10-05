import 'package:air2money/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'router/router.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final authService = AuthService();
  await authService.loadUserFromStorage();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(
      ChangeNotifierProvider(
        create: (_) => authService,
        child: MyApp(authService: authService),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Air2Money',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.darkTheme(context),
      routerConfig: createRouter(
        authService,
      ), // <-- factory receives authService
    );
  }
}
