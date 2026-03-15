import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/core_constants.dart';
import '../../utils/widgets/flexible_sized_button.dart';
import '../../utils/auth_global.dart';
import 'profile_service.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final profile = jsonDecode(AuthGlobal.instance?.getProfileData() ?? {});

    nameController.text = profile["name"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return ChangeNotifierProvider(
      create: (_) => ProfileService(context),

      child: Scaffold(
        appBar: AppBar(title: const Text("Edit Profile")),

        body: Consumer<ProfileService>(
          builder: (_, service, __) {
            return Padding(
              padding: EdgeInsets.all(size.width * 0.06),

              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                  ),

                  SizedBox(height: size.height * 0.03),

                  FlexibleSizedButton(
                    buttonName: "Save",
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      await service.updateProfile(name: nameController.text);

                      if (service.profileStatus.screenState ==
                          ScreenStateEnum.success) {
                        navigator.pop();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
