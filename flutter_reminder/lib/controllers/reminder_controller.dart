import 'package:flutter/material.dart';
import 'package:flutter_reminder/componetes/reminder.dart';
import 'package:intl/intl.dart';

class ReminderController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  DateTime selectDate = DateTime.now();
  final List<DayReminders> reminderListController = [];

  void createReminder() {
    final String reminder = nameController.text;
    final String date = dateController.text;

    if (reminder.isEmpty || date.isEmpty) {
      //TODO add toast
      return;
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

    print('Nome: $reminder');
    print('Data: $date');
  }

  bool DeleteReminder(String reminder, DateTime date) {
    int index =
        reminderListController.indexWhere((item) => item.date == date);
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
