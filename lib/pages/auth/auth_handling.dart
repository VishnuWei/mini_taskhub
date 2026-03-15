import 'dart:convert';
import 'package:flutter/material.dart';

import '../../utils/auth_global.dart';
import '../../utils/core_constants.dart';

class AuthHandling {
  final BuildContext authContext;
  AuthHandling(this.authContext);

  static Future<void> saveAuthData(Map<String, dynamic> data) async {
    final global = await AuthGlobal.getInstance();

    final session = data['session'];
    final profile = data['profile'];

    if (session != null) {
      global.update(AuthPrefs.session, jsonEncode(session));
      global.update(AuthPrefs.sessionId, session['access_token']);
    }

    if (profile != null) {
      global.update(AuthPrefs.profile, jsonEncode(profile));
      global.update(AuthPrefs.profileId, profile['id']);
    }
  }

  static Future<CommonStatus> restoreSession() async {
    try {
      final global = await AuthGlobal.getInstance();

      final sessionString = global.get(AuthPrefs.session);
      final profileString = global.get(AuthPrefs.profile);

      final sessionId = global.get(AuthPrefs.sessionId);
      final profileId = global.get(AuthPrefs.profileId);

      if (sessionString == null || profileString == null) {
        return CommonStatus.error("Session not found");
      }

      final session = sessionString is String
          ? jsonDecode(sessionString)
          : sessionString;

      final profile = profileString is String
          ? jsonDecode(profileString)
          : profileString;

      final data = {
        "session": session,
        "profile": profile,
        "sessionId": sessionId,
        "profileId": profileId,
      };

      return CommonStatus.success(data);
    } catch (e) {
      return CommonStatus.error(e.toString());
    }
  }

  navigateAfterAuth(String homeRoute, String authRoute, CommonStatus status) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (status.screenState == ScreenStateEnum.success) {
        Navigator.pushNamedAndRemoveUntil(
          authContext,
          homeRoute,
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          authContext,
          authRoute,
          (route) => false,
        );
      }
    });
  }

  logout(String authRoute) async {
    final global = await AuthGlobal.getInstance();

    global.clearPrefs();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(
        authContext,
        authRoute,
        (route) => false,
      );
    });
  }
}
