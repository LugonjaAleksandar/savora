import 'package:flutter/material.dart';
import 'package:savora/core/theme/app_colors.dart';

extension BuildContextX on BuildContext {
  AppColors get colors => AppColors.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;
}
