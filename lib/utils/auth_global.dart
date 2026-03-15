import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthPrefs {
  session,
  sessionId,
  profile,
  profileId,
}
class AuthGlobal extends ChangeNotifier {

  SharedPreferences? pref;
  late Map<AuthPrefs, dynamic> serverData;

  AuthGlobal(this.pref) {
    serverData = {};
    for (var name in AuthPrefs.values) {
      String key = name.toString();
      if (pref !=null  && pref!.containsKey(key)) {
        serverData[name] = pref!.get(key);
      }
    }
  }

  static AuthGlobal? instance;

  static Future<AuthGlobal> getInstance()  async {
    if(instance == null)    {
      await createInstance();
    }
    return instance!;
  }

  static createInstance() async {

    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      instance = AuthGlobal(pref);
    }
    catch(e){
      debugPrint("$e");
      instance = AuthGlobal(null);
    }
  }

  getProfileData() {
    if (!serverData.containsKey(AuthPrefs.profile) || serverData[AuthPrefs.profile] == null) {
      serverData[AuthPrefs.profile] = <String, dynamic>{};
    }
    return serverData[AuthPrefs.profile];
  }

  dynamic get(AuthPrefs key) {
    if (serverData.containsKey(key) ) {
      return serverData[key];
    }
    return null;
  }

  String getSessionId() {
    if (serverData.containsKey(AuthPrefs.sessionId)) {
      return serverData[AuthPrefs.sessionId];
    }
    throw Error();//redirect to login
  }

  getSessionData() {
    if (!serverData.containsKey(AuthPrefs.session)) {
      serverData[AuthPrefs.session] = <String, dynamic>{};
    }
    return serverData[AuthPrefs.session];
  }

  update(AuthPrefs key, value) {
    serverData[key] = value;
    if(pref!=null){
      pref!.setString(key.toString(), value.toString());
    }
  }

  void clearPrefs() {
    update(AuthPrefs.session, {});
    update(AuthPrefs.sessionId, null);
    update(AuthPrefs.profile, {});
    update(AuthPrefs.profileId, null);
  }
}