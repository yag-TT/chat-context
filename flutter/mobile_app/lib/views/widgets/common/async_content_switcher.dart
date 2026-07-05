import 'package:flutter/material.dart';

import 'async_content_status_config.dart';
import 'status_content.dart';

class AsyncContentSwitcher<T extends Object> extends StatelessWidget {
  const AsyncContentSwitcher({
    super.key,
    required this.data,
    required this.dataBuilder,
    required this.errorMessage,
    required this.statusConfig,
  });

  final T? data;
  final Widget Function(BuildContext context, T data) dataBuilder;
  final String? errorMessage;
  final AsyncContentStatusConfig statusConfig;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [AsyncContentSwitcher] ::build() - UIを描画します');
    final data = this.data;
    if (data != null) {
      return dataBuilder(context, data);
    }

    final errorMessage = this.errorMessage;
    if (errorMessage != null) {
      return StatusContent.error(
        icon: statusConfig.errorIcon,
        title: errorMessage,
        style: statusConfig.style,
        onRetryPressed: statusConfig.onRetryPressed,
      );
    }

    return StatusContent.loading(
      icon: statusConfig.loadingIcon,
      title: statusConfig.loadingTitle,
      style: statusConfig.style,
    );
  }
}
