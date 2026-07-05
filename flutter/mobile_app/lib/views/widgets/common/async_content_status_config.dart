import 'package:flutter/material.dart';

import 'status_content_style.dart';

class AsyncContentStatusConfig {
  const AsyncContentStatusConfig({
    required this.errorIcon,
    required this.loadingIcon,
    required this.loadingTitle,
    required this.style,
    required this.onRetryPressed,
  });

  final IconData errorIcon;
  final IconData loadingIcon;
  final String loadingTitle;
  final StatusContentStyle style;
  final VoidCallback onRetryPressed;
}
