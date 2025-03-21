import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'router/router.dart';
import 'theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Air2Money',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.darkTheme(context),
      routerConfig: appRouter,
    );
  }
}
