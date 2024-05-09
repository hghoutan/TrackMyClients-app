import 'package:flutter/material.dart';

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
  lastDate ??= firstDate.add(const Duration(days: 365 * 200));

  DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (context, child) {
      return DatePickerTheme(
          data: const DatePickerThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
          child: child!);
    },
  );

  if (selectedDate == null) return null;

  if (!context.mounted) return selectedDate;

  TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    initialEntryMode: TimePickerEntryMode.input,
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: TimePickerTheme(
            data: TimePickerThemeData(
              backgroundColor: Colors.white,
            ),
            child: child!),
      );
    },
  );
  if (selectedTime != null) {
    final now = DateTime.now();
    final chosenDateTime = DateTime(
        now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
    if (chosenDateTime.isBefore(now)) {
      selectedTime = TimeOfDay.now();
    }
  }

  return selectedTime == null
      ? selectedDate
      : DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
}
