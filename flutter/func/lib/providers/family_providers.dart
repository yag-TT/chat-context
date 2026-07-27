import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/family_message.dart';

final environmentProvider = Provider<String>(
  (ref) => '通常環境',
  name: 'environment',
  dependencies: const [],
);

final greetingProvider = Provider.family<FamilyMessage, String>(
  (ref, name) {
    final environment = ref.watch(environmentProvider);
    return createFamilyMessage(environment: environment, name: name);
  },
  name: 'greeting',
  dependencies: [environmentProvider],
);

FamilyMessage createFamilyMessage({
  required String environment,
  required String name,
}) {
  final normalizedName = name.trim().isEmpty ? 'ゲスト' : name.trim();
  return FamilyMessage(
    text: '$environment: こんにちは、$normalizedNameさん',
    evaluatedAt: DateTime.now(),
  );
}
