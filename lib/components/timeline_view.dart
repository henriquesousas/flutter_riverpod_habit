import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

class TimelineView extends StatelessWidget {
  final DateTime seletedDate;
  final void Function(DateTime) onSelectedDateChanged;

  const TimelineView({
    super.key,
    required this.seletedDate,
    required this.onSelectedDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: EasyDateTimeLine(
        locale: "pt_br",
        initialDate: seletedDate,
        onDateChange: onSelectedDateChanged,
        headerProps: const EasyHeaderProps(
          monthPickerType: MonthPickerType.dropDown,
          showHeader: false,
          showSelectedDate: true,
        ),
        dayProps: EasyDayProps(
          dayStructure: DayStructure.dayStrDayNumMonth,
          activeDayStyle: DayStyle(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dayStrStyle: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            dayNumStyle: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          inactiveDayStyle: DayStyle(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colorScheme.surface,
              border: Border.all(
                color: colorScheme.outlineVariant,
              ),
            ),
            dayStrStyle: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16,
            ),
            dayNumStyle: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 16,
            ),
          ),
          todayHighlightStyle: TodayHighlightStyle.withBackground,
          todayHighlightColor: colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
