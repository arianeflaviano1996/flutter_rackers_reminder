import 'package:flutter/cupertino.dart';
import 'package:flutter_reminder/model/reminder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_reminder/controllers/reminder_controller.dart';
import 'package:intl/intl.dart';

void main() {
  group('ReminderController', () {
    late ReminderController controller;

    setUp(() {
      controller = ReminderController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('createReminder should add a reminder to the list', () {
      // Arrange
      final reminder = 'Test Reminder';
      final date = '2023-06-30';

      // Act
      controller.nameController.text = reminder;
      controller.dateController.text = date;
      controller.selectDate = DateTime.parse(date);
      controller.createReminder();

      // Assert
      expect(controller.reminderListController.length, 1);
      expect(controller.reminderListController[0].name, contains(reminder));
      expect(controller.reminderListController[0].date, DateTime.parse(date));
    });

    test('createReminder should throw an error when name is missing', () {
      // Arrange
      final date = '2023-06-30';

      // Act & Assert
      expect(() {
        controller.nameController.text = '';
        controller.dateController.text = date;
        controller.selectDate = DateTime.parse(date);
        controller.createReminder();
      }, throwsA(isA<ErrorHint>()));
    });

    test('createReminder should throw an error when date is in the past', () {
      // Arrange
      final reminder = 'Test Reminder';
      final pastDate = DateTime.now().subtract(Duration(days: 1));

      // Act & Assert
      expect(() {
        controller.nameController.text = reminder;
        controller.dateController.text = DateFormat('yyyy-MM-dd').format(pastDate);
        controller.selectDate = pastDate;
        controller.createReminder();
      }, throwsA(isA<ErrorHint>()));
    });

    test('DeleteReminder should remove a reminder from the list', () {
      // Arrange
      final reminder = 'Test Reminder';
      final date = DateTime.now();

      controller.reminderListController.add(DayReminders(date: date, name: [reminder]));

      // Act
      final deleted = controller.DeleteReminder(reminder, date);

      // Assert
      expect(deleted, true);
      expect(controller.reminderListController.length, 0);
    });

    test('containsDate should return true when date is in the list', () {
      // Arrange
      final date = DateTime.now();
      controller.reminderListController.add(DayReminders(date: date, name: []));

      // Act
      final contains = controller.containsDate(date);

      // Assert
      expect(contains, true);
    });

    test('containsDate should return false when date is not in the list', () {
      // Arrange
      final date = DateTime.now();

      // Act
      final contains = controller.containsDate(date);

      // Assert
      expect(contains, false);
    });
  });
}
