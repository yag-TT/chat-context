import 'package:flutter/material.dart';

import 'settings_styles.dart';

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [SettingsGroup] ::build() - UIを描画します');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: settingsGroupTitlePadding,
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: settingsStrongAccentColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        DecoratedBox(
          decoration: settingsGroupDecoration,
          child: Column(children: children),
        ),
      ],
    );
  }
}
