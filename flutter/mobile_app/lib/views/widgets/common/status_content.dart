import 'package:flutter/material.dart';

import 'screen_surface.dart';
import 'status_content_body.dart';
import 'status_content_style.dart';

class StatusContent extends StatelessWidget {
  const StatusContent._({
    super.key,
    required this.icon,
    required this.title,
    required this.style,
    this.actionLabel,
    this.onActionPressed,
  });

  const StatusContent.loading({
    Key? key,
    required IconData icon,
    required String title,
    required StatusContentStyle style,
  }) : this._(key: key, icon: icon, title: title, style: style);

  const StatusContent.error({
    Key? key,
    required IconData icon,
    required String title,
    required StatusContentStyle style,
    required VoidCallback onRetryPressed,
  }) : this._(
         key: key,
         icon: icon,
         title: title,
         style: style,
         actionLabel: '再読み込み',
         onActionPressed: onRetryPressed,
       );

  final IconData icon;
  final String title;
  final StatusContentStyle style;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [StatusContent] ::build() - UIを描画します');
    final content = Center(
      child: StatusContentBody(
        icon: icon,
        title: title,
        style: style,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
      ),
    );

    return ScreenSurface(
      decoration: style.decoration,
      useSafeArea: style.useSafeArea,
      child: content,
    );
  }
}
