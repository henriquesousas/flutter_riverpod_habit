import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum DateFormatTypes { dayMontYear }

extension DateTimeFormatting on DateTime {
  String toFormattedString(String format) => DateFormat(format).format(this);
}

extension TimeOfDayFormattingExtension on TimeOfDay {
  String toFormattedString() {
    final DateTime dateTime = DateTime(
      0, // year
      0, // month
      0, // day
      hour,
      minute,
    );
    String period = (hour >= 12) ? 'PM' : 'AM';
    return "${DateFormat('HH:mm').format(dateTime)} $period";
  }
}
