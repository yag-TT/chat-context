import 'dart:async';

import 'package:flutter/material.dart';

import '../navigation/app_route_observer.dart';
import '../services/background_notification_service.dart';
import '../widgets/demo_info_card.dart';

class BackgroundNotificationScreen extends StatefulWidget {
  const BackgroundNotificationScreen({super.key, this.scheduler});

  final BackgroundNotificationScheduler? scheduler;

  @override
  State<BackgroundNotificationScreen> createState() =>
      _BackgroundNotificationScreenState();
}

class _BackgroundNotificationScreenState
    extends State<BackgroundNotificationScreen>
    with WidgetsBindingObserver, RouteAware {
  static const _notificationDelay = Duration(seconds: 5);

  late final BackgroundNotificationScheduler _scheduler;

  bool _isCurrentRoute = false;
  bool _isRouteObserverRegistered = false;
  bool _isRequestingPermission = false;
  bool? _permissionsGranted;
  int _backgroundSession = 0;
  String _status = '通知権限を確認しています。';

  @override
  void initState() {
    super.initState();
    _scheduler = widget.scheduler ?? AwesomeBackgroundNotificationScheduler();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_refreshPermissions());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isRouteObserverRegistered) {
      return;
    }

    final route = ModalRoute.of(context);
    if (route != null) {
      appRouteObserver.subscribe(this, route);
      _isRouteObserverRegistered = true;
    }
  }

  @override
  void didPush() {
    _isCurrentRoute = true;
  }

  @override
  void didPopNext() {
    _isCurrentRoute = true;
    unawaited(_refreshPermissions());
  }

  @override
  void didPushNext() {
    _disableFeature();
  }

  @override
  void didPop() {
    _disableFeature();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isCurrentRoute) {
      return;
    }

    switch (state) {
      case AppLifecycleState.paused:
        if (_permissionsGranted == true) {
          final session = ++_backgroundSession;
          _setStatus('バックグラウンド移動を検知。5秒後の通知を予約しています。');
          unawaited(_scheduleForSession(session));
        } else {
          _setStatus('通知には「通知」と「正確なアラーム」の許可が必要です。');
        }
        break;
      case AppLifecycleState.resumed:
        _backgroundSession++;
        _setStatus('アプリに戻ったため、未表示の通知予約を解除しました。');
        unawaited(_cancelSchedule());
        unawaited(_refreshPermissions());
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<void> _scheduleForSession(int session) async {
    try {
      await _scheduler.cancelSchedule();
      if (!_isSessionActive(session)) {
        return;
      }

      await _scheduler.scheduleAfter(_notificationDelay);
      if (!_isSessionActive(session)) {
        await _scheduler.cancelSchedule();
        return;
      }

      _setStatus('通知を予約しました。バックグラウンドのまま5秒お待ちください。');
    } catch (error) {
      if (_isSessionActive(session)) {
        _setStatus('通知の予約に失敗しました: $error');
      }
    }
  }

  bool _isSessionActive(int session) {
    return mounted &&
        _isCurrentRoute &&
        session == _backgroundSession &&
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.paused;
  }

  Future<void> _cancelSchedule() async {
    try {
      await _scheduler.cancelSchedule();
    } catch (error) {
      _setStatus('通知予約の解除に失敗しました: $error');
    }
  }

  Future<void> _refreshPermissions() async {
    try {
      final granted = await _scheduler.arePermissionsGranted();
      if (!mounted) {
        return;
      }
      setState(() {
        _permissionsGranted = granted;
        _status = granted
            ? '準備完了。ホームボタンなどでアプリをバックグラウンドに移動してください。'
            : '通知には「通知」と「正確なアラーム」の許可が必要です。';
      });
    } catch (error) {
      _setStatus('通知権限を確認できませんでした: $error');
    }
  }

  Future<void> _requestPermissions() async {
    if (_isRequestingPermission) {
      return;
    }
    setState(() {
      _isRequestingPermission = true;
      _status = 'Androidの通知設定を確認しています。';
    });

    try {
      final granted = await _scheduler.requestPermissions();
      if (!mounted) {
        return;
      }
      setState(() {
        _permissionsGranted = granted;
        _status = granted
            ? '準備完了。ホームボタンなどでアプリをバックグラウンドに移動してください。'
            : '必要な権限が許可されていません。ボタンから設定を確認してください。';
      });
    } catch (error) {
      _setStatus('通知権限を要求できませんでした: $error');
    } finally {
      if (mounted) {
        setState(() => _isRequestingPermission = false);
      }
    }
  }

  void _disableFeature() {
    _isCurrentRoute = false;
    _backgroundSession++;
    unawaited(_cancelSchedule());
  }

  void _setStatus(String status) {
    if (mounted) {
      setState(() => _status = status);
    }
  }

  @override
  void dispose() {
    _isCurrentRoute = false;
    _backgroundSession++;
    WidgetsBinding.instance.removeObserver(this);
    if (_isRouteObserverRegistered) {
      appRouteObserver.unsubscribe(this);
    }
    unawaited(_scheduler.cancelSchedule());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final granted = _permissionsGranted == true;

    return Scaffold(
      appBar: AppBar(title: const Text('バックグラウンド通知')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const DemoInfoCard(
              title: '動作',
              description:
                  'この画面を開いたままアプリをバックグラウンドにすると、その瞬間を起点に5秒後の通知を予約します。'
                  '5秒以内にアプリへ戻ると予約を解除します。',
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          granted
                              ? Icons.notifications_active_outlined
                              : Icons.notifications_off_outlined,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            granted ? '通知の準備ができています' : '通知権限を確認してください',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _status,
                      key: const Key('background-notification-status'),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      key: const Key('background-notification-permission'),
                      onPressed: _isRequestingPermission
                          ? null
                          : _requestPermissions,
                      icon: _isRequestingPermission
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.settings_outlined),
                      label: Text(granted ? '権限を再確認' : '通知を許可'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('試し方', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('1. 「通知を許可」で必要な権限を有効にする'),
                    Text('2. この画面に戻り、ホームボタンを押す'),
                    Text('3. バックグラウンドのまま5秒待つ'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
