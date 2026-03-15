import 'package:flutter/material.dart';
import 'package:mini_taskhub/pages/dashboard/dashboard_screen.dart';

import 'auth/auth_screen.dart';
import 'auth/splash_screen.dart';
import 'profile/my_profile_view_screen.dart';
import 'profile/profile_edit_screen.dart';

class AppRoutes {
  static const String splashScreen = '/';
  static const String authScreen = '/auth_screen';
  
  static const String myProfileScreen = '/my_profile_screen';
  static const String profileEditScreen = '/profile_edit_screen';

  static const String homeScreen = '/home_screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: splashScreen),
          builder: (_) {
            return SplashScreen();
          },
        );
      case authScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: authScreen),
          builder: (_) {
            return AuthScreen();
          },
        );
      case homeScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: homeScreen),
          builder: (_) {
            return DashboardScreen();
          },
        );
      case myProfileScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: myProfileScreen),
          builder: (_) {
            return MyProfileViewScreen();
          },
        );
      case profileEditScreen:
        return MaterialPageRoute(
          settings: const RouteSettings(name: profileEditScreen),
          builder: (_) {
            return ProfileEditScreen();
          },
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
