import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'observers/provider_log.dart';

class PlaygroundRoot extends StatefulWidget {
  const PlaygroundRoot({super.key});

  @override
  State<PlaygroundRoot> createState() => _PlaygroundRootState();
}

class _PlaygroundRootState extends State<PlaygroundRoot> {
  late final ProviderLogStore _store;
  late final PlaygroundObserver _observer;

  @override
  void initState() {
    super.initState();
    _store = ProviderLogStore();
    _observer = PlaygroundObserver(_store);
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: [_observer],
      overrides: [providerLogStoreProvider.overrideWithValue(_store)],
      child: const MyApp(),
    );
  }
}
