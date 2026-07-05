import 'package:flutter/foundation.dart';

import 'fan_mode.dart';
import 'iot_control_constraints.dart';
import 'iot_sensor_reading.dart';

/// IoT操作画面に表示する操作状態とセンサー取得結果をまとめた状態です。
///
/// 数値項目はコンストラクタで正規化し、画面側が範囲外の値を保持しないようにします。
class IotControlState {
  IotControlState({
    this.isHomeOnline = true,
    this.isLivingLightOn = true,
    this.isEntranceLocked = true,
    this.isAirPurifierOn = false,
    double lightBrightness = iotDefaultLightBrightness,
    double targetTemperature = iotDefaultTargetTemperature,
    this.fanMode = FanMode.auto,
    List<IotSensorReading> sensorReadings = const [],
    this.hasLoadedSensorReadings = false,
  }) : lightBrightness = normalizeLightBrightness(lightBrightness),
       targetTemperature = normalizeTargetTemperature(targetTemperature),
       // ViewModel外から後続変更されないよう、表示用リストを固定化します。
       sensorReadings = List.unmodifiable(sensorReadings);

  final bool isHomeOnline;
  final bool isLivingLightOn;
  final bool isEntranceLocked;
  final bool isAirPurifierOn;
  final double lightBrightness;
  final double targetTemperature;
  final FanMode fanMode;
  final List<IotSensorReading> sensorReadings;
  final bool hasLoadedSensorReadings;

  IotControlState copyWith({
    bool? isHomeOnline,
    bool? isLivingLightOn,
    bool? isEntranceLocked,
    bool? isAirPurifierOn,
    double? lightBrightness,
    double? targetTemperature,
    FanMode? fanMode,
    List<IotSensorReading>? sensorReadings,
    bool? hasLoadedSensorReadings,
  }) {
    debugPrint('[DBG] [IotControlState] ::copyWith() - 変更後の状態を作成します');
    return IotControlState(
      isHomeOnline: isHomeOnline ?? this.isHomeOnline,
      isLivingLightOn: isLivingLightOn ?? this.isLivingLightOn,
      isEntranceLocked: isEntranceLocked ?? this.isEntranceLocked,
      isAirPurifierOn: isAirPurifierOn ?? this.isAirPurifierOn,
      lightBrightness: lightBrightness ?? this.lightBrightness,
      targetTemperature: targetTemperature ?? this.targetTemperature,
      fanMode: fanMode ?? this.fanMode,
      sensorReadings: sensorReadings ?? this.sensorReadings,
      hasLoadedSensorReadings:
          hasLoadedSensorReadings ?? this.hasLoadedSensorReadings,
    );
  }

  IotControlState withLoadedSensorReadings(
    List<IotSensorReading> sensorReadings,
  ) {
    debugPrint(
      '[DBG] [IotControlState] ::withLoadedSensorReadings() - 取得済みセンサー情報を状態へ反映します',
    );
    return copyWith(
      sensorReadings: sensorReadings,
      hasLoadedSensorReadings: true,
    );
  }

  @override
  bool operator ==(Object other) {
    debugPrint('[DBG] [IotControlState] ::operator==() - 同じ値か比較します');
    return identical(this, other) ||
        other is IotControlState &&
            other.isHomeOnline == isHomeOnline &&
            other.isLivingLightOn == isLivingLightOn &&
            other.isEntranceLocked == isEntranceLocked &&
            other.isAirPurifierOn == isAirPurifierOn &&
            other.lightBrightness == lightBrightness &&
            other.targetTemperature == targetTemperature &&
            other.fanMode == fanMode &&
            listEquals(other.sensorReadings, sensorReadings) &&
            other.hasLoadedSensorReadings == hasLoadedSensorReadings;
  }

  @override
  int get hashCode {
    debugPrint('[DBG] [IotControlState] ::hashCode() - ハッシュ値を計算します');
    return Object.hash(
      isHomeOnline,
      isLivingLightOn,
      isEntranceLocked,
      isAirPurifierOn,
      lightBrightness,
      targetTemperature,
      fanMode,
      Object.hashAll(sensorReadings),
      hasLoadedSensorReadings,
    );
  }
}
