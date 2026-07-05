import 'package:flutter/foundation.dart';

/// IoT操作画面の数値入力で使う制約値と正規化処理です。
///
/// Sliderの表示範囲とViewModelへ保存される値の範囲を同じ定義から参照し、
/// UIと状態の制約がずれないようにしています。
const iotDefaultLightBrightness = 72.0;
const iotMinLightBrightness = 0.0;
const iotMaxLightBrightness = 100.0;
const iotLightBrightnessStep = 5.0;
const iotLightBrightnessDivisions =
    ((iotMaxLightBrightness - iotMinLightBrightness) ~/ iotLightBrightnessStep);

const iotDefaultTargetTemperature = 24.0;
const iotMinTargetTemperature = 18.0;
const iotMaxTargetTemperature = 30.0;
const iotTargetTemperatureStep = 0.5;
const iotTargetTemperatureDivisions =
    ((iotMaxTargetTemperature - iotMinTargetTemperature) ~/
    iotTargetTemperatureStep);

double normalizeLightBrightness(double value) {
  debugPrint('[DBG] [Global] ::normalizeLightBrightness() - 照明の明るさを有効範囲に丸めます');
  return value.clamp(iotMinLightBrightness, iotMaxLightBrightness).toDouble();
}

double normalizeTargetTemperature(double value) {
  debugPrint('[DBG] [Global] ::normalizeTargetTemperature() - 目標温度を有効範囲に丸めます');
  return value
      .clamp(iotMinTargetTemperature, iotMaxTargetTemperature)
      .toDouble();
}
