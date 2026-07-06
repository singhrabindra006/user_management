import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HourlyForecastItem extends StatelessWidget {
  final DateTime time;
  final IconData icon;
  final String temperature;

  const HourlyForecastItem({
    super.key,
    required this.icon,
    required this.time,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('h:mm a').format(time);

    final int hour = time.hour;

    Color iconColor;
    if (hour >= 6 && hour < 12) {
      iconColor = Colors.orange.shade300;
    } else if (hour >= 12 && hour < 17) {
      iconColor = Colors.amber.shade600;
    } else if (hour >= 17 && hour < 21) {
      iconColor = Colors.deepOrange.shade400;
    } else {
      iconColor = Colors.indigo.shade300;
    }

    List<Color> gradientColors;
    if (hour >= 6 && hour < 12) {
      gradientColors = [Colors.orange.shade50, Colors.yellow.shade50];
    } else if (hour >= 12 && hour < 17) {
      gradientColors = [Colors.blue.shade50, Colors.lightBlue.shade50];
    } else if (hour >= 17 && hour < 21) {
      gradientColors = [Colors.deepOrange.shade50, Colors.orange.shade50];
    } else {
      gradientColors = [Colors.indigo.shade50, Colors.purple.shade50];
    }

    return Card(
      elevation: 10,
      color: Colors.transparent,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Text(
              formattedTime,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 5),
            Icon(icon, size: 32, color: iconColor),
            const SizedBox(height: 5),
            Text(
              temperature,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
