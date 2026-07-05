import '../../models/iot_control_state.dart';

abstract class IotControlPreferencesRepository {
  Future<IotControlState?> loadState();

  Future<void> saveState(IotControlState state);
}
