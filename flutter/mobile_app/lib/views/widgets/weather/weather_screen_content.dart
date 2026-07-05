import 'package:flutter/material.dart';

import '../../../models/weather_snapshot.dart';
import '../common/async_content_status_config.dart';
import '../common/async_content_switcher.dart';
import 'weather_home_content.dart';
import 'weather_styles.dart';

/// 天気データの取得状態に応じて、読み込み・エラー・天気表示を切り替えます。
class WeatherScreenContent extends StatelessWidget {
  const WeatherScreenContent({
    super.key,
    required this.weather,
    required this.errorMessage,
    required this.onRetryPressed,
  });

  final WeatherSnapshot? weather;
  final String? errorMessage;
  final VoidCallback onRetryPressed;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [WeatherScreenContent] ::build() - 画面を描画します');
    return AsyncContentSwitcher<WeatherSnapshot>(
      data: weather,
      dataBuilder: (context, weather) => WeatherHomeContent(weather: weather),
      errorMessage: errorMessage,
      statusConfig: AsyncContentStatusConfig(
        errorIcon: Icons.cloud_off_rounded,
        loadingIcon: Icons.cloud_sync_rounded,
        loadingTitle: '天気情報を読み込み中',
        style: weatherStatusStyle,
        onRetryPressed: onRetryPressed,
      ),
    );
  }
}
