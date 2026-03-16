import 'package:flutter/material.dart';
import 'package:mini_taskhub/pages/auth/auth_service.dart';
import 'package:mini_taskhub/pages/profile/profile_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/app_routes.dart';
import 'pages/dashboard/task_service.dart';
import 'pages/services/supabase_service.dart';
import 'pages/services/theme_notifier.dart';
import 'utils/app_color_scheme.dart';
import 'utils/strings.dart';
import 'utils/themes.dart';

final navigatorKey = GlobalKey<NavigatorState>();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Strings.supabaseUrl,
    anonKey: Strings.supabaseKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SupabaseService()),
        ChangeNotifierProxyProvider<SupabaseService, AuthService>(
          create: (context) => AuthService(context.read<SupabaseService>()),
          update: (context, supabase, previous) => AuthService(supabase),
        ),
        ChangeNotifierProxyProvider<SupabaseService, TaskService>(
          create: (context) => TaskService(context.read<SupabaseService>()),
          update: (context, supabase, previous) => TaskService(supabase),
        ),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProxyProvider<SupabaseService, ProfileService>(
          create: (context) => ProfileService(context),
          update: (context, supabase, previous) =>
              previous ?? ProfileService(context),
        ),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (_, theme, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: buildTheme(AppColorScheme.light),
            darkTheme: buildTheme(AppColorScheme.dark),
            themeMode: theme.themeMode,
            navigatorKey: navigatorKey,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
