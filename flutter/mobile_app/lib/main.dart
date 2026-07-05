import 'package:flutter/material.dart';

import 'core/app_dependencies.dart';
import 'core/app_theme.dart';
import 'views/home_page.dart';

void main() {
  debugPrint('[DBG] [Global] ::main() - アプリを起動します');
  runApp(MyApp());
}

/// アプリの起点です。
///
/// Repositoryの実装は [AppDependencies] として外から渡せるため、
/// 本番用・モック用・テスト用の依存を差し替えやすくしています。
class MyApp extends StatelessWidget {
  MyApp({super.key, AppDependencies? dependencies})
    : dependencies = dependencies ?? AppDependencies.local();

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    debugPrint('[DBG] [MyApp] ::build() - UIを描画します');
    return MaterialApp(
      title: 'MVVM Demo',
      theme: AppTheme.light,
      home: HomePage(dependencies: dependencies),
    );
  }
}
