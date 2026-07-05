import 'package:flutter/material.dart';

const iotBackgroundColor = Color(0xFFF4F7FA);
const iotBackgroundDecoration = BoxDecoration(color: iotBackgroundColor);
const iotTextPrimaryColor = Color(0xFF172032);
const iotTextSecondaryColor = Color(0xFF637083);
const iotOnlineColor = Color(0xFF1B7F6B);

const iotPanelDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(8)),
  border: Border.fromBorderSide(BorderSide(color: Color(0x0F000000))),
  boxShadow: [
    BoxShadow(color: Color(0x0D000000), blurRadius: 16, offset: Offset(0, 8)),
  ],
);
