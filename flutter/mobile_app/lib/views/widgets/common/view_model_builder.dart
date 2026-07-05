import 'package:flutter/widgets.dart';

typedef ViewModelWidgetBuilder<T extends Listenable> =
    Widget Function(BuildContext context, T viewModel);

class ViewModelBuilder<T extends Listenable> extends StatelessWidget {
  const ViewModelBuilder({
    super.key,
    required this.viewModel,
    required this.builder,
  });

  final T viewModel;
  final ViewModelWidgetBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [ViewModelBuilder] ::build() - UIを描画します');
    return AnimatedBuilder(
      animation: viewModel,
      builder: (context, _) => builder(context, viewModel),
    );
  }
}
