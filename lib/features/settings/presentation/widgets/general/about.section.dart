// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:worth_loop/features/settings/presentation/screens/general_settings.screen.dart';
import 'package:worth_loop/i18n/strings.g.dart';
import 'package:worth_loop/shared/theme/app_spacing_theme_extension.dart';

/// "About" group inside [GeneralSettingsScreen] — copyright and privacy link.
class AboutSection extends StatelessWidget {
  /// Called when the user requests the privacy policy.
  final VoidCallback onOpenPrivacyPolicy;

  const AboutSection({super.key, required this.onOpenPrivacyPolicy});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.settings.general.about.title, style: textTheme.labelSmall),
        SizedBox(height: context.spacing.xs),
        Text(t.settings.general.about.copyright, style: textTheme.bodyMedium),
        SizedBox(height: context.spacing.xs),
        TextButton(
          key: const Key('general-settings-privacy-policy-button'),
          onPressed: onOpenPrivacyPolicy,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(t.settings.general.about.privacyPolicy),
        ),
      ],
    );
  }
}
