import 'package:flutter/material.dart';
import 'package:flutter_reminder/componetes/reminder.dart';

class RemindersPage extends StatefulWidget {
  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  List<List<Reminder>> reminders = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  void addReminder() {
    String name = nameController.text;
    DateTime date = DateTime.parse(dateController.text);

    if (name.isEmpty || date.isBefore(DateTime.now())) {
      // Validation for invalid fields
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in the fields correctly.'),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    Reminder newReminder = Reminder(name: name, date: date);

    // Check if a day with the same date already exists
    bool existingDay = false;
    for (var reminderList in reminders) {
      if (reminderList[0].date.year == date.year &&
          reminderList[0].date.month == date.month &&
          reminderList[0].date.day == date.day) {
        existingDay = true;
        break;
      }
    }

    if (existingDay) {
      // Add the reminder to the existing day
      for (var reminderList in reminders) {
        if (reminderList[0].date.year == date.year &&
            reminderList[0].date.month == date.month &&
            reminderList[0].date.day == date.day) {
          setState(() {
            reminderList.add(newReminder);
          });
          break;
        }
      }
    } else {
      // Create a new day with the reminder
      setState(() {
        reminders.add([newReminder]);
      });
    }

    // Clear the input fields
    nameController.clear();
    dateController.clear();
  }

  void deleteReminder(Reminder reminder) {
    for (var day in reminders) {
      if (day.contains(reminder)) {
        setState(() {
          day.remove(reminder);
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders List'),
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (BuildContext context, int index) {
          List<Reminder> day = reminders[index];
          DateTime dayDate = day[0].date;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${dayDate.month}/${dayDate.day}/${dayDate.year}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: day.length,
                itemBuilder: (BuildContext context, int index) {
                  Reminder reminder = day[index];

                  return ListTile(
                    title: Text(reminder.name),
                    subtitle: Text(
                      '${reminder.date.hour}:${reminder.date.minute}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Reminder'),
                              content: Text(
                                'Are you sure you want to delete this reminder?',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    deleteReminder(reminder);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('New Reminder'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: dateController,
                      decoration: InputDecoration(labelText: 'Date'),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Create'),
                    onPressed: () {
                      addReminder();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
