import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;

  void decrement() => state--;

  void reset() => state = 0;
}

final counterProvider = NotifierProvider<CounterNotifier, int>(
  CounterNotifier.new,
  name: 'counter',
);

final counterLabelProvider = Provider<String>((ref) {
  final count = ref.watch(counterProvider);
  return count.isEven ? '$count は偶数です' : '$count は奇数です';
}, name: 'counterLabel');
