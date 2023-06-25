import 'package:flutter/material.dart';
import 'package:flutter_reminder/model/reminder.dart';
import 'package:intl/intl.dart';

class ReminderController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  DateTime selectDate = DateTime.now();
  final List<DayReminders> reminderListController = [];

  void createReminder() {
    final String reminder = nameController.text;
    final String date = dateController.text;
    DateTime currentDate = DateTime.now();
    DateTime firstHourOfToday = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      0, // Hora
      0, // Minuto
      0, // Segundo
      0, // Milissegundo
    );

    if (reminder.isEmpty || date.isEmpty) {
      throw ErrorHint('Name or date are missing! please fill the fields');
    }
    if (selectDate.isBefore(firstHourOfToday)) {
      throw ErrorHint('Select the date from today on ');
    }

    if (containsDate(selectDate)) {
      // A data está presente na lista
      int index =
          reminderListController.indexWhere((item) => item.date == selectDate);

      reminderListController[index].name.add(reminder);
    } else {
      // A data não está presente na lista
      reminderListController
          .add(DayReminders(date: selectDate, name: [reminder]));
    }

    reminderListController.sort((a, b) => a.date.compareTo(b.date));
  }

  bool DeleteReminder(String reminder, DateTime date) {
    int index = reminderListController.indexWhere((item) => item.date == date);
    bool deleted = reminderListController[index].name.remove(reminder);
    if (reminderListController[index].name.isEmpty) {
      reminderListController.removeAt(index);
    }

    return deleted;
  }

  bool containsDate(DateTime date) {
    return reminderListController.any((item) => item.date == date);
  }

  void dispose() {
    nameController.dispose();
    dateController.dispose();
  }
}
