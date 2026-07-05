import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/app_screen.dart';
import 'package:mobile_app/views/widgets/navigation/screen_destinations.dart';

void main() {
  test('screenDestinationFor returns matching destination', () {
    final destination = screenDestinationFor(AppScreen.notifications);

    expect(destination.screen, AppScreen.notifications);
    expect(destination.title, '通知');
  });

  test('screenDestinationsFor returns destinations in default order', () {
    final destinations = screenDestinationsFor([
      AppScreen.settings,
      AppScreen.home,
    ]);

    expect(destinations.map((destination) => destination.screen), [
      AppScreen.home,
      AppScreen.settings,
    ]);
  });
}
