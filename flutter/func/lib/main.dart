import 'package:flutter/material.dart';

import 'playground_root.dart';
import 'services/background_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AwesomeBackgroundNotificationScheduler.initialize();
  runApp(const PlaygroundRoot());
}
