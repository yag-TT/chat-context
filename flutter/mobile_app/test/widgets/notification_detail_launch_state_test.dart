import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/core/mock_data/mock_notification_data.dart';
import 'package:mobile_app/views/widgets/notification/notification_detail_launch_state.dart';

void main() {
  test(
    'allows launch only when mounted with a notification and no open sheet',
    () {
      final launchState = NotificationDetailLaunchState();
      final notification = mockNotifications.first;

      expect(launchState.canLaunch(null, isMounted: true), isFalse);
      expect(launchState.canLaunch(notification, isMounted: false), isFalse);
      expect(launchState.canLaunch(notification, isMounted: true), isTrue);

      launchState.markOpened();

      expect(launchState.canLaunch(notification, isMounted: true), isFalse);

      launchState.markClosed();

      expect(launchState.canLaunch(notification, isMounted: true), isTrue);
    },
  );
}
