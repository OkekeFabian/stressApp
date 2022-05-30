import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';

import 'command_class.dart';

//For the User to add Google Commands with other details

class CommandEntryDialog extends StatefulWidget {
  final String initialDay;
  final CommandEntry commandEntryToEdit;

  CommandEntryDialog.add(this.initialDay) : commandEntryToEdit = null;

  CommandEntryDialog.edit(this.commandEntryToEdit)
      : initialDay = commandEntryToEdit.command;

  @override
  // ignore: no_logic_in_create_state
  CommandEntryDialogState createState() {
    if (commandEntryToEdit != null) {
      return CommandEntryDialogState(commandEntryToEdit.dateTime,
          commandEntryToEdit.day, commandEntryToEdit.command);
    } else {
      return CommandEntryDialogState(DateTime.now(), initialDay, "Never");
    }
  }
}

class CommandEntryDialogState extends State<CommandEntryDialog> {
  DateTime _dateTime = DateTime.now();
  String _day;
  String _command;

  final _textController2 = TextEditingController();

  List<String> dayOptions = [
    'Every Monday',
    'Every Tuesday',
    'Every Wednesday',
    'Every Thursday',
    'Every Friday',
    'Every Saturday',
    'Every Sunday',
  ];

  CommandEntryDialogState(this._dateTime, this._day, this._command);

  Widget _createAppBar(BuildContext context) {
    return AppBar(
      title: widget.commandEntryToEdit == null
          ? const Text("New entry")
          : const Text("Edit entry"),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(CommandEntry(_dateTime, _day, _command));
          },
          child: const Text(
            'SAVE',
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Lottie.asset(assetName, width: 150.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(context),
      body: SingleChildScrollView(
        child: KeyboardDismisser(
          gestures: const [GestureType.onTap],
          child: Column(
            children: [
              Card(
                child: ListTile(
                  leading: Icon(Icons.today, color: Colors.grey[500]),
                  title: DateTimeItem(
                    dateTime: _dateTime,
                    onChanged: (dateTime) =>
                        setState(() => _dateTime = dateTime),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.bar_chart, color: Colors.grey[500]),
                  title: const Text('Repeat'),
                  trailing: PopupMenuButton<String>(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: Text(
                        _command.toString(),
                      ),
                    ),
                    onSelected: (String value) {
                      setState(() {
                        _command = value;
                      });
                    },
                    itemBuilder: (context) {
                      return dayOptions
                          .map<PopupMenuItem<String>>((String value) {
                        return PopupMenuItem(
                            child: Text(value.toString()), value: value);
                      }).toList();
                    },
                  ),
                ),
              ),
              const Card(
                child: ListTile(
                  leading: Text('->',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15)),
                  title: Text(
                      'Type in an Instruction or Sets of Instructions to complete and include a duration if needed',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15)),
                ),
              ),
              ListTile(
                leading: Icon(Icons.speaker_notes, color: Colors.grey[500]),
                title: TextFormField(
                  minLines: 3,
                  maxLines: 6,
                  controller: _textController2,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "e.g Turn on the Light for 20 minutes",
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      suffixIcon: _textController2.text.isNotEmpty
                          ? IconButton(
                              onPressed: () => _textController2.clear(),
                              icon: const Icon(Icons.clear))
                          : null),
                  validator: (command) => command != null && command.isEmpty
                      ? 'Please fill in a command'
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateTimeItem extends StatelessWidget {
  DateTimeItem({Key key, DateTime dateTime, @required this.onChanged})
      : assert(onChanged != null),
        date = dateTime == null
            ? DateTime.now()
            : DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = dateTime == null
            ? DateTime.now()
            : TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: (() => _showDatePicker(context)),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(DateFormat('EEEE, MMMM d').format(date))),
          ),
        ),
        InkWell(
          onTap: (() => _showTimePicker(context)),
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('$time')),
        ),
      ],
    );
  }

  Future _showDatePicker(BuildContext context) async {
    DateTime dateTimePicked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: date.subtract(const Duration(days: 20000)),
        lastDate: DateTime.now());

    if (dateTimePicked != null) {
      onChanged(DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, time.hour, time.minute));
    }
  }

  Future _showTimePicker(BuildContext context) async {
    TimeOfDay timeOfDay =
        await showTimePicker(context: context, initialTime: time);

    if (timeOfDay != null) {
      onChanged(DateTime(
          date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute));
    }
  }
}
