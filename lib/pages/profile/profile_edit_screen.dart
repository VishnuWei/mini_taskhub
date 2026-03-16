import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/core_constants.dart';
import '../../utils/widgets/flexible_sized_button.dart';
import '../../utils/response_handler.dart';
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

    final profile = context.read<ProfileService>().profile;

    nameController.text = profile["name"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final service = context.watch<ProfileService>();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.06),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            SizedBox(height: size.height * 0.03),

            ResponseHandler.getResponseWidget(
              context,
              service.profileStatus,
              buildButton(service),
              initialWidget: buildButton(service),
              errorWidget: buildButton(service),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(ProfileService service) {
    return FlexibleSizedButton(
      buttonName: "Save",
      onPressed: () async {
        final navigator = Navigator.of(context);

        await service.updateProfile(name: nameController.text);

        if (service.profileStatus.screenState == ScreenStateEnum.success) {
          navigator.pop();
        }
      },
    );
  }
}
