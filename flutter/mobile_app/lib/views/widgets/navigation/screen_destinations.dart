import 'package:flutter/material.dart';

import '../../../models/app_screen.dart';
import 'screen_destination.dart';

const defaultScreenDestinations = [
  ScreenDestination(
    screen: AppScreen.home,
    title: 'ホーム画面',
    description: '現在地の天気と今後の予報を表示します。',
    icon: Icons.wb_sunny_outlined,
    color: Colors.lightBlue,
  ),
  ScreenDestination(
    screen: AppScreen.search,
    title: '検索',
    description: 'データの検索や絞り込みを行う画面です。',
    icon: Icons.search,
    color: Colors.indigo,
  ),
  ScreenDestination(
    screen: AppScreen.notifications,
    title: '通知',
    description: 'お知らせや更新情報を確認する画面です。',
    icon: Icons.notifications_none,
    color: Colors.deepOrange,
  ),
  ScreenDestination(
    screen: AppScreen.settings,
    title: '設定',
    description: 'アカウントやアプリの設定を変更する画面です。',
    icon: Icons.settings_outlined,
    color: Colors.blueGrey,
  ),
];

ScreenDestination screenDestinationFor(AppScreen screen) {
  debugPrint('[DBG] [Global] ::screenDestinationFor() - 画面種別に対応する表示定義を取得します');
  return defaultScreenDestinations.firstWhere(
    (destination) => destination.screen == screen,
  );
}

List<ScreenDestination> screenDestinationsFor(Iterable<AppScreen> screens) {
  debugPrint('[DBG] [Global] ::screenDestinationsFor() - 表示可能な画面メニュー定義を取得します');
  final screenSet = screens.toSet();
  return [
    for (final destination in defaultScreenDestinations)
      if (screenSet.contains(destination.screen)) destination,
  ];
}
