import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LiveClock extends StatefulWidget {
  final int timezoneOffset;

  const LiveClock({super.key, required this.timezoneOffset});

  @override
  State<LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  late Timer _timer;
  late String _currentTime;

  @override
  void initState() {
    super.initState();
    _updateTime();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _updateTime();
      }
    });
  }

  void _updateTime() {
    final DateTime nowUtc = DateTime.now().toUtc();
    final DateTime localNow = nowUtc.add(
      Duration(seconds: widget.timezoneOffset),
    );

    final DateFormat dateFormat = DateFormat('EEEE, MMMM d');
    final DateFormat timeFormat = DateFormat('h:mm:ss a');
    final String dateString = dateFormat.format(localNow);
    final String timeString = timeFormat.format(localNow);

    setState(() {
      _currentTime = '$dateString, $timeString';
    });
  }

  @override
  void didUpdateWidget(LiveClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.timezoneOffset != widget.timezoneOffset) {
      _updateTime();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Color _getTimeColor() {
    final DateTime nowUtc = DateTime.now().toUtc();
    final DateTime localNow = nowUtc.add(
      Duration(seconds: widget.timezoneOffset),
    );
    final int hour = localNow.hour;

    if (hour >= 6 && hour < 12) {
      return Colors.orange.shade700;
    } else if (hour >= 12 && hour < 17) {
      return Colors.amber.shade600;
    } else if (hour >= 17 && hour < 21) {
      return Colors.deepOrange.shade400;
    } else {
      return Colors.indigo.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentTime,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: _getTimeColor(),
      ),
    );
  }
}
