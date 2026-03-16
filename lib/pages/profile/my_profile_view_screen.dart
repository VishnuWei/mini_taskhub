import 'package:flutter/material.dart';
import 'package:mini_taskhub/pages/profile/profile_service.dart';
import 'package:provider/provider.dart';

import '../../pages/app_routes.dart';
import '../auth/auth_service.dart';
import '../../utils/widgets/flexible_sized_button.dart';
import '../services/theme_notifier.dart';

class MyProfileViewScreen extends StatefulWidget {
  const MyProfileViewScreen({super.key});

  @override
  State<MyProfileViewScreen> createState() => _MyProfileViewScreenState();
}

class _MyProfileViewScreenState extends State<MyProfileViewScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileService>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final profileService = context.watch<ProfileService>();
    final themeNotifier = context.watch<ThemeNotifier>();

    final authService = context.read<AuthService>();

    final email = authService.currentUser?.email ?? "";

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("My Profile"), centerTitle: true),

        body: Padding(
          padding: EdgeInsets.all(size.width * 0.06),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name", style: textTheme.bodySmall),

              Text(
                profileService.profile["name"] ?? "",
                style: textTheme.bodyLarge,
              ),

              SizedBox(height: size.height * 0.02),

              Text("Email", style: textTheme.bodySmall),

              Text(email, style: textTheme.bodyLarge),

              SizedBox(height: size.height * 0.03),

              SwitchListTile(
                value: themeNotifier.isDark,
                title: Text("Dark Mode", style: textTheme.bodyLarge),
                activeColor: colorScheme.primary,
                onChanged: themeNotifier.toggleTheme,
              ),

              SizedBox(height: size.height * 0.04),

              FlexibleSizedButton(
                buttonName: "Edit Profile",
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.profileEditScreen);
                },
              ),

              SizedBox(height: size.height * 0.02),

              FlexibleSizedButton(
                backgroundColor: colorScheme.error,
                textColor: colorScheme.onError,
                buttonName: "Logout",
                onPressed: () async {
                  final navigator = Navigator.of(context);

                  await context.read<AuthService>().logout();

                  navigator.pushNamedAndRemoveUntil(
                    AppRoutes.authScreen,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
