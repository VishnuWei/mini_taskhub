import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/core_constants.dart';
import '../services/supabase_service.dart';

class ProfileService extends ChangeNotifier {
  final BuildContext context;

  ProfileService(this.context);

  CommonStatus profileStatus = CommonStatus.initial();

  Map<String, dynamic> profile = {};

  loadProfile() async {
    try {
      final supabase = context.read<SupabaseService>().client;

      final user = supabase.auth.currentUser;

      if (user == null) return;

      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      profile = Map<String, dynamic>.from(response);

      notifyListeners();
    } catch (e) {
      debugPrint("Profile load error: $e");
    }
  }

  void updateProfileData(Map<String, dynamic> newProfile) {
    profile = newProfile;
    notifyListeners();
  }

  updateProfile({required String name}) async {
    profileStatus = CommonStatus.loading();
    notifyListeners();

    try {
      final supabase = context.read<SupabaseService>().client;

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

      profile = Map<String, dynamic>.from(response);

      profileStatus = CommonStatus.success(profile);

      notifyListeners();
    } catch (e) {
      profileStatus = CommonStatus.error(e.toString());
      notifyListeners();
    }
  }
}