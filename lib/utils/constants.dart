import 'package:flutter/material.dart';

const _cyberRed = Color.fromARGB(255, 171, 0, 0);
const _pureBlack = Colors.black;
const _pureWhite = Colors.white;

final colorScheme = ColorScheme.fromSeed(
  primary: _cyberRed,
  onPrimary: _pureWhite,
  secondary: _pureWhite,
  onSecondary: _pureBlack,
  surface: _pureBlack,
  onSurface: _pureWhite,
  seedColor: const Color.fromARGB(255, 61, 0, 1),
  brightness: Brightness.dark,
);
