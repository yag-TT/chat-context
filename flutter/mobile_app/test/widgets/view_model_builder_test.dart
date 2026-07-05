import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/views/widgets/common/view_model_builder.dart';

import '../helpers/widget_test_app.dart';

void main() {
  testWidgets('rebuilds when the view model notifies listeners', (
    tester,
  ) async {
    final viewModel = _TestViewModel();
    addTearDown(viewModel.dispose);

    await pumpWidgetInApp(
      tester,
      ViewModelBuilder<_TestViewModel>(
        viewModel: viewModel,
        builder: (context, viewModel) => Text('${viewModel.count}'),
      ),
    );

    expect(find.text('0'), findsOneWidget);

    viewModel.increment();
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });
}

class _TestViewModel extends ChangeNotifier {
  var count = 0;

  void increment() {
    count += 1;
    notifyListeners();
  }
}
