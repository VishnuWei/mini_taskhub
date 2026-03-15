import 'package:flutter/material.dart';
import 'package:mini_taskhub/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/core_constants.dart';
import '../../utils/auth_global.dart';
import '../profile/profile_service.dart';
import '../services/supabase_service.dart';
import 'auth_handling.dart';
import 'auth_ui_def.dart';

class AuthService extends ChangeNotifier {
  final SupabaseService supabaseService;

  AuthService(this.supabaseService);

  CommonStatus loginStatus = CommonStatus.initial();
  CommonStatus signupStatus = CommonStatus.initial();

  User? get currentUser => supabaseService.client.auth.currentUser;

  bool get isLoggedIn => currentUser != null;

  int authScreens = AuthUiDef.screens.length;
  int currentScreenIndex = 0;

  void updateScreenIndex(int index) {
    if (index < 0 || index >= authScreens) return;
    currentScreenIndex = index;
    notifyListeners();
  }

  Future<void> checkSession() async {
    loginStatus = CommonStatus.loading();
    notifyListeners();
    final profileService = ProfileService(navigatorKey.currentContext!);

    try {
      final session = supabaseService.client.auth.currentSession;
      final user = supabaseService.client.auth.currentUser;

      if (session == null || user == null) {
        loginStatus = CommonStatus.error("No session");
        notifyListeners();
        return;
      }

      final profile = await supabaseService.fetchProfile(user.id);
      profileService.updateProfileData(profile);

      final data = {"session": session.toJson(), "profile": profile};

      await AuthHandling.saveAuthData(data);

      loginStatus = CommonStatus.success(data);
      notifyListeners();
    } catch (e) {
      loginStatus = CommonStatus.error(e.toString());
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async {
    loginStatus = CommonStatus.loading();
    notifyListeners();
    final profileService = ProfileService(navigatorKey.currentContext!);

    try {
      final response = await supabaseService.signIn(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {
        loginStatus = CommonStatus.error("Login failed");
        notifyListeners();
        return;
      }

      final profile = await supabaseService.fetchProfile(user.id);

      final data = {"session": response.session?.toJson(), "profile": profile};
      profileService.updateProfileData(profile);

      await AuthHandling.saveAuthData(data);

      loginStatus = CommonStatus.success(data);
      notifyListeners();
    } catch (e) {
      loginStatus = CommonStatus.error(e.toString());
      notifyListeners();
    }
  }

  signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    signupStatus = CommonStatus.loading();
    notifyListeners();
    final profileService = ProfileService(navigatorKey.currentContext!);

    try {
      final response = await supabaseService.signUp(
        name: name,
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) {
        signupStatus = CommonStatus.error("Signup failed");
        notifyListeners();
        return;
      }

      final profile = await supabaseService.fetchProfile(user.id);

      final data = {"session": response.session?.toJson(), "profile": profile};
      profileService.updateProfileData(profile);

      await AuthHandling.saveAuthData(data);

      signupStatus = CommonStatus.success(data);
      notifyListeners();
    } catch (e) {
      signupStatus = CommonStatus.error(e.toString());
      notifyListeners();
    }
  }

  Future<void> googleLogin() async {
    loginStatus = CommonStatus.loading();
    notifyListeners();
    final profileService = ProfileService(navigatorKey.currentContext!);

    try {
      await supabaseService.signInWithGoogle();

      final user = supabaseService.client.auth.currentUser;
      final session = supabaseService.client.auth.currentSession;

      if (user == null) {
        loginStatus = CommonStatus.error("Google login failed");
        notifyListeners();
        return;
      }

      final profile = await supabaseService.fetchProfile(user.id);

      profileService.updateProfileData(profile);

      final data = {"session": session?.toJson(), "profile": profile};

      await AuthHandling.saveAuthData(data);

      loginStatus = CommonStatus.success(data);
      notifyListeners();
    } catch (e) {
      loginStatus = CommonStatus.error(e.toString());
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final profileService = ProfileService(navigatorKey.currentContext!);
    await supabaseService.logout();

    final global = await AuthGlobal.getInstance();
    global.clearPrefs();
    profileService.updateProfileData({});

    loginStatus = CommonStatus.initial();
    signupStatus = CommonStatus.initial();

    notifyListeners();
  }
}
