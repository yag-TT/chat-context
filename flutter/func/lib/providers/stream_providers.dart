import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ticker_configuration.dart';

final tickerIntervalProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 500),
  name: 'tickerInterval',
);

final tickerProvider = StreamProvider.autoDispose
    .family<int, TickerConfiguration>(
      (ref, configuration) {
        return Stream<int>.periodic(configuration.interval, (value) {
          final errorAfter = configuration.errorAfter;
          if (errorAfter != null && value >= errorAfter) {
            throw StateError('$errorAfterイベント後の意図的なエラー');
          }
          return value;
        });
      },
      name: 'ticker',
      retry: (retryCount, error) => null,
    );
