import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? labelColor;
  final Color? valueColor;
  final Color? textColor;

  const AdditionalInformation({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
    this.backgroundColor,
    this.labelColor,
    this.valueColor,
    this.textColor,
  });

  Color _getDefaultIconColor() {
    final lower = label.toLowerCase();
    if (lower.contains('humid')) return Colors.blue.shade600;
    if (lower.contains('wind')) return Colors.teal.shade500;
    if (lower.contains('press')) return Colors.purple.shade500;
    return Colors.grey.shade600;
  }

  List<Color> _getDefaultGradient() {
    final lower = label.toLowerCase();
    if (lower.contains('humid')) {
      return [Colors.blue.shade50, Colors.blue.shade100];
    } else if (lower.contains('wind')) {
      return [Colors.teal.shade50, Colors.teal.shade100];
    } else if (lower.contains('press')) {
      return [Colors.purple.shade50, Colors.purple.shade100];
    } else {
      return [Colors.grey.shade50, Colors.grey.shade100];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveIconColor = iconColor ?? _getDefaultIconColor();
    final effectiveLabelColor =
        labelColor ?? theme.textTheme.bodySmall?.color?.withValues();
    final effectiveValueColor = valueColor ?? theme.textTheme.bodyMedium?.color;
    final gradientColors = backgroundColor != null
        ? [backgroundColor!, backgroundColor!.withValues()]
        : _getDefaultGradient();

    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: effectiveIconColor),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: effectiveLabelColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: effectiveValueColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
