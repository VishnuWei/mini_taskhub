import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../form_data_notifier.dart';

class CustomPrivacyPolicyWidget extends StatelessWidget {
  final FormDataNotifier formDataChangeNotifier;
  final Map<String, dynamic> config;
  late final CustomPrivacyPolicyNotifier _notifier;

  CustomPrivacyPolicyWidget(
    this.formDataChangeNotifier,
    this.config, {
    super.key,
  }) {
    _notifier = CustomPrivacyPolicyNotifier(config, formDataChangeNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, child) {
        return privacyPolicy(context);
      },
    );
  }

  Widget privacyPolicy(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _notifier.boxChecked,
          child: Icon(
            _notifier.tAndCApplied
                ? Icons.check_box
                : Icons.check_box_outline_blank,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            softWrap: true,
            text: TextSpan(
              text: config['checkBoxText'],
              style: Theme.of(context).textTheme.bodyMedium,
              children: List.generate(config['termsAndConditionText'].length, (
                index,
              ) {
                final item = config['termsAndConditionText'][index];
                return TextSpan(
                  text: item['text'] ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (item['url'] != null && item['url'].isNotEmpty) {
                        _notifier.clickingUrl(url: item['url']);
                      }
                    },
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomPrivacyPolicyNotifier extends ChangeNotifier {
  final Map<String, dynamic> config;
  final FormDataNotifier formDataChangeNotifier;

  CustomPrivacyPolicyNotifier(this.config, this.formDataChangeNotifier);

  bool tAndCApplied = false;

  boxChecked() {
    tAndCApplied = !tAndCApplied;
    formDataChangeNotifier.updateValue(config['fieldName'], tAndCApplied);
    notifyListeners();
  }

  clickingUrl({required String url}) async {
    // Uri finalUri = Uri.parse(url);
    // if (!await launchUrl(finalUri)) {
    // throw Exception('Could not launch $url');
    // }
  }
}
