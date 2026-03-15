import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/images.dart';
import '../../utils/core_constants.dart';
import '../auth/auth_service.dart';
import '../app_routes.dart';
import 'auth_handling.dart';

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
    final authHandling = AuthHandling(context);

    final localStatus = await AuthHandling.restoreSession();

    if (localStatus.screenState == ScreenStateEnum.success) {
      await authService.checkSession();

      authHandling.navigateAfterAuth(
        AppRoutes.homeScreen,
        AppRoutes.authScreen,
        authService.loginStatus,
      );
    } else {
      authHandling.navigateAfterAuth(
        AppRoutes.homeScreen,
        AppRoutes.authScreen,
        localStatus,
      );
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
            /// App Logo
            Image.asset(Images.appLogo, height: size.height * 0.12),

            SizedBox(height: size.height * 0.02),

            /// App Name
            Text(
              "Mini TaskHub",
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),

            SizedBox(height: size.height * 0.03),

            /// Splash Illustration
            Image.asset(Images.splashImage, height: size.height * 0.25),

            SizedBox(height: size.height * 0.04),

            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
