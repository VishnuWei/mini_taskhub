import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/images.dart';
import '../auth/auth_service.dart';
import '../app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final authService = context.read<AuthService>();
    final navigator = Navigator.of(context);


    await Future.delayed(const Duration(milliseconds: 800));

    await authService.checkSession();

    if (authService.isLoggedIn) {
      navigator.pushReplacementNamed(AppRoutes.homeScreen);
    } else {
      navigator.pushReplacementNamed(AppRoutes.authScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.appLogo, height: size.height * 0.12),

            SizedBox(height: size.height * 0.02),

            Text(
              "Mini TaskHub",
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),

            SizedBox(height: size.height * 0.04),

            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}