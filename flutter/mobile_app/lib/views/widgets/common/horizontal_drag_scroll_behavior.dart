import 'dart:ui';

import 'package:flutter/material.dart';

class HorizontalDragScrollBehavior extends MaterialScrollBehavior {
  const HorizontalDragScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices {
    return {
      PointerDeviceKind.touch,
      PointerDeviceKind.mouse,
      PointerDeviceKind.stylus,
      PointerDeviceKind.trackpad,
    };
  }
}
