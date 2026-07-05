import 'package:flutter/material.dart';

const settingsBackgroundColor = Color(0xFFF6F8FB);
const settingsBackgroundDecoration = BoxDecoration(
  color: settingsBackgroundColor,
);
const settingsGroupBorderColor = Color(0xFFE2E7EF);
const settingsContentPadding = EdgeInsets.fromLTRB(20, 20, 20, 96);
const settingsHeaderToGroupSpacing = 18.0;
const settingsGroupSpacing = 14.0;
const settingsGroupTitlePadding = EdgeInsets.only(left: 4, bottom: 8);
const settingsHeaderIconSize = 54.0;
const settingsHeaderIconRadius = 8.0;
const settingsHeaderTextSpacing = 14.0;
const settingsHeaderTitleSpacing = 4.0;

final settingsAccentColor = Colors.blueGrey.shade700;
final settingsStrongAccentColor = Colors.blueGrey.shade800;
final settingsTitleColor = Colors.blueGrey.shade900;
final settingsSubtitleColor = Colors.blueGrey.shade600;

const settingsGroupDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(8)),
  border: Border.fromBorderSide(BorderSide(color: settingsGroupBorderColor)),
);
