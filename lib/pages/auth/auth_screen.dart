import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mini_taskhub/pages/app_routes.dart';
import 'package:mini_taskhub/utils/images.dart';
import 'package:mini_taskhub/utils/response_handler.dart';
import 'package:mini_taskhub/utils/widgets/flexible_sized_button.dart';
import 'package:provider/provider.dart';

import '../../utils/core_constants.dart';
import '../../utils/form_data_notifier.dart';
import '../../utils/widgets/widget_factory.dart';
import 'auth_service.dart';
import 'auth_ui_def.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FormDataNotifier formNotifier = FormDataNotifier();

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final size = MediaQuery.sizeOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        body: ListenableBuilder(
          listenable: authService,
          builder: (context, _) {
            final currentScreen = Map<String, dynamic>.from(
              AuthUiDef.screens[authService.currentScreenIndex],
            );
            List<Map<String, dynamic>> fields = List<Map<String, dynamic>>.from(
              currentScreen["fields"] ?? [],
            );
            bool isWelcomeScreen = fields.isEmpty;
            if (isWelcomeScreen) {
              return WelcomeScreen(authService: authService);
            }
            final titles = List<Map<String, dynamic>>.from(
              currentScreen["logoTitle"] ?? [],
            );

            bool isSignUp = currentScreen['type'] == 'signup';

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(currentScreen["logoImage"]),
                      RichText(
                        text: TextSpan(
                          text: titles.first['text'],
                          style: textTheme.headlineSmall,
                          children: [
                            TextSpan(
                              text: titles.last['text'],
                              style: textTheme.headlineSmall?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.05),
                  Expanded(
                    child: ListView(
                      children: [
                        Text(
                          currentScreen["title"],
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: size.height * 0.01),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...WidgetFactory.buildFromList(
                              context,
                              fields,
                              formNotifier,
                            ),
                            SizedBox(height: size.height * 0.02),
                            if (currentScreen['type'] == 'login')
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text(
                                    'Forgot Password?',
                                    style: textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            if (currentScreen['type'] == 'signup')
                              WidgetFactory.build(
                                context,
                                AuthUiDef.privacyPolicyField,
                                formNotifier,
                              ),
                            SizedBox(height: size.height * 0.02),
                            ResponseHandler.getResponseWidget(
                              context,
                              isSignUp
                                  ? authService.signupStatus
                                  : authService.loginStatus,
                              initialWidget: buildButton(
                                context,
                                currentScreen,
                                authService,
                              ),
                              errorWidget: buildButton(
                                context,
                                currentScreen,
                                authService,
                              ),
                              buildButton(context, currentScreen, authService),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 1,
                              width: size.width * 0.3,
                              color: colorScheme.onSecondary,
                            ),
                            Text(
                              'Or continue with',
                              style: textTheme.bodyMedium,
                            ),
                            Container(
                              height: 1,
                              width: size.width * 0.3,
                              color: colorScheme.onSecondary,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.04),
                        FlexibleSizedButton(
                          borderRadius: 0,
                          onPressed: () {
                            authService.googleLogin();
                          },
                          backgroundColor: colorScheme.surface,
                          textColor: colorScheme.onSurface,
                          borderColor: colorScheme.onSurface,
                          leading: Image.asset(
                            Images.googlePng,
                            height: 20,
                            width: 20,
                            color: colorScheme.onSurface,
                          ),
                          buttonName: 'Google',
                        ),
                        SizedBox(height: size.height * 0.02),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: currentScreen["type"] == "login"
                                  ? "Don't have an account? "
                                  : "Already have an account? ",
                              style: textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: currentScreen["type"] == "login"
                                      ? "Sign Up"
                                      : "Log In",
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      authService.updateScreenIndex(
                                        authService.currentScreenIndex == 1
                                            ? 2
                                            : 1,
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildButton(
    BuildContext context,
    Map<String, dynamic> currentScreen,
    AuthService authService,
  ) {
    return FlexibleSizedButton(
      borderRadius: 0,
      onPressed: () async {
        debugPrint('Form Data: ${formNotifier.formData}');
        final navigator = Navigator.of(context);
        if (currentScreen['type'] == 'login') {
          await context
              .read<AuthService>()
              .login(
                email: formNotifier.formData['email'] ?? '',
                password: formNotifier.formData['password'] ?? '',
              )
              .then((_) {
                if (authService.loginStatus.screenState ==
                    ScreenStateEnum.success) {
                  navigator.pushReplacementNamed(AppRoutes.homeScreen);
                }
                debugPrint(
                  'auth status: ${authService.loginStatus.screenState}',
                );
                debugPrint(
                  'auth successData: ${authService.loginStatus.successData}',
                );
                debugPrint(
                  'auth errorText: ${authService.loginStatus.errorText}',
                );
              });
        } else {
          await context
              .read<AuthService>()
              .signUp(
                email: formNotifier.formData['email'] ?? '',
                password: formNotifier.formData['password'] ?? '',
                name: formNotifier.formData['name'] ?? '',
              )
              .then((_) {
                if (authService.signupStatus.screenState ==
                    ScreenStateEnum.success) {
                  navigator.pushReplacementNamed(AppRoutes.homeScreen);
                }
                debugPrint(
                  'signup status: ${authService.signupStatus.screenState}',
                );
                debugPrint(
                  'signup successData: ${authService.signupStatus.successData}',
                );
                debugPrint(
                  'signup errorText: ${authService.signupStatus.errorText}',
                );
              });
        }
      },
      buttonName: currentScreen["buttonText"],
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  final AuthService authService;
  const WelcomeScreen({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    final currentScreen = AuthUiDef.screens[authService.currentScreenIndex];
    final size = MediaQuery.sizeOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final titles = List<Map<String, dynamic>>.from(
      currentScreen["richTitle"] ?? [],
    );
    final content = List<Map<String, dynamic>>.from(
      currentScreen["richContent"] ?? [],
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(currentScreen["logoImage"]),
              RichText(
                text: TextSpan(
                  text: titles.first['text'],
                  style: textTheme.headlineSmall,
                  children: [
                    TextSpan(
                      text: titles.last['text'],
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: colorScheme.onSurface,
                child: Image.asset(
                  currentScreen["splashImage"],
                  alignment: Alignment.center,
                  height: size.height * 0.30,
                  width: size.width * 0.9,
                ),
              ),
            ],
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '${content.first['text']}',
                style: TextStyle(
                  fontSize: size.height * 0.085,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                children: List.generate(content.length - 1, (i) => i + 1)
                    .map(
                      (i) => TextSpan(
                        text: '${content[i]['text']}',
                        style: TextStyle(
                          fontSize: size.height * 0.085,
                          fontWeight: FontWeight.bold,
                          color: content[i]['isPrimary']
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          FlexibleSizedButton(
            borderRadius: 0,
            onPressed: () {
              authService.updateScreenIndex(authService.currentScreenIndex + 1);
            },
            buttonName: currentScreen["buttonText"],
          ),
        ],
      ),
    );
  }
}
