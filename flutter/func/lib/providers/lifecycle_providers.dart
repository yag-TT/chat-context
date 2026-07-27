import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/lifecycle_event.dart';

@immutable
class LifecycleProbeConfiguration {
  const LifecycleProbeConfiguration({
    required this.recorder,
    required this.keepAlive,
  });

  final LifecycleRecorder recorder;
  final bool keepAlive;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LifecycleProbeConfiguration &&
            identical(recorder, other.recorder) &&
            keepAlive == other.keepAlive;
  }

  @override
  int get hashCode => Object.hash(identityHashCode(recorder), keepAlive);
}

final lifecycleProbeProvider = Provider.autoDispose
    .family<int, LifecycleProbeConfiguration>((ref, configuration) {
      final recorder = configuration.recorder;
      recorder.record(LifecycleEventType.created);
      if (configuration.keepAlive) {
        ref.keepAlive();
      }
      ref.onCancel(() => recorder.record(LifecycleEventType.cancelled));
      ref.onResume(() => recorder.record(LifecycleEventType.resumed));
      ref.onDispose(() => recorder.record(LifecycleEventType.disposed));
      return DateTime.now().microsecondsSinceEpoch;
    }, name: 'lifecycleProbe');
