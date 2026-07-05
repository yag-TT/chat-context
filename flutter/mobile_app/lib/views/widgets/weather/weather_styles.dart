import 'package:flutter/material.dart';

import '../common/status_content_style.dart';

const weatherBackgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4A8FE7), Color(0xFF4270C8), Color(0xFF243D8F)],
  ),
);

final weatherStatusStyle = StatusContentStyle(
  decoration: weatherBackgroundDecoration,
  iconColor: Colors.white.withValues(alpha: 0.86),
  titleColor: Colors.white,
);
