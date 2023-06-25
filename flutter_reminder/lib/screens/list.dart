import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/reminder_controller.dart';

class ReminderList extends StatelessWidget {
  final ReminderController _controller = ReminderController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _controller.reminderListController.length,
      itemBuilder: (context, index) {
        final reminder = _controller.reminderListController[index];
        final dateFormatted = DateFormat.yMd('pt_BR').format(reminder.date);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateFormatted,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: reminder.name.length,
              itemBuilder: (context, innerIndex) {
                final name = reminder.name[innerIndex];
                return ListTile(
                  title: Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.white,
                    onPressed: () {
                      _controller.DeleteReminder(name, reminder.date);
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
