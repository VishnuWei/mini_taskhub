import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/core_constants.dart';
import '../services/supabase_service.dart';
import '../../utils/auth_global.dart';

class ProfileService extends ChangeNotifier {
  final BuildContext profileContext;

  ProfileService(this.profileContext);

  CommonStatus profileStatus = CommonStatus.initial();
  Map<String, dynamic> profile = {};

  updateProfileData(Map<String, dynamic> newProfile) {
    profile = newProfile;
    notifyListeners();
  }

  Future<void> updateProfile({required String name}) async {
    profileStatus = CommonStatus.loading();
    notifyListeners();

    try {
      final supabase = profileContext.read<SupabaseService>().client;

      final user = supabase.auth.currentUser;

      if (user == null) {
        profileStatus = CommonStatus.error("User not found");
        notifyListeners();
        return;
      }

      final response = await supabase
          .from('profiles')
          .update({"name": name})
          .eq('id', user.id)
          .select()
          .single();
      updateProfileData(response);    

      /// update local cache
      final global = await AuthGlobal.getInstance();

      global.update(AuthPrefs.profile, response);

      profileStatus = CommonStatus.success(response);

      notifyListeners();
    } catch (e) {
      profileStatus = CommonStatus.error(e.toString());
      notifyListeners();
    }
  }
}
