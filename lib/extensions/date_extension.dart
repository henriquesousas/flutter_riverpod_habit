import 'package:intl/intl.dart';

enum DateFormatTypes { dayMontYear }

extension DateTimeFormatting on DateTime {
  String toFormattedString(String format) => DateFormat(format).format(this);
}
