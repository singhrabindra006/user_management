import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class WeatherConditionIcon {
  static IconData getWeatherIcon(int conditionId) {
    if (conditionId >= 200 && conditionId < 300) {
      return LucideIcons.cloud_lightning;
    } else if (conditionId >= 300 && conditionId < 400) {
      return LucideIcons.cloud_drizzle;
    } else if (conditionId >= 500 && conditionId < 600) {
      return LucideIcons.cloud_rain;
    } else if (conditionId >= 600 && conditionId < 700) {
      return LucideIcons.cloud_snow;
    } else if (conditionId >= 700 && conditionId < 800) {
      return LucideIcons.cloud_fog;
    } else if (conditionId == 800) {
      return LucideIcons.sun;
    } else if (conditionId > 800 && conditionId < 900) {
      return LucideIcons.cloud;
    } else {
      return LucideIcons.cloud;
    }
  }

  static Color getWeatherColor(int conditionId) {
    if (conditionId >= 200 && conditionId < 300) {
      return Colors.orange.shade700;
    } else if (conditionId >= 300 && conditionId < 400) {
      return Colors.blue.shade400;
    } else if (conditionId >= 500 && conditionId < 600) {
      return Colors.blue.shade700;
    } else if (conditionId >= 600 && conditionId < 700) {
      return Colors.cyan.shade300;
    } else if (conditionId >= 700 && conditionId < 800) {
      return Colors.grey.shade500;
    } else if (conditionId == 800) {
      return Colors.amber.shade600;
    } else if (conditionId > 800 && conditionId < 900) {
      return Colors.grey.shade400;
    } else {
      return Colors.grey.shade400;
    }
  }
}
