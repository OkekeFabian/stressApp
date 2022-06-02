import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'command_class.dart';

//For the User to add Google Commands with other details

class CommandEntryDialog extends StatefulWidget {
  final CommandEntry commandEntry;
  final Function(
    DateTime dateTime,
    String day,
    String command,
  ) onClickedDone;

  const CommandEntryDialog(
      {Key key, this.commandEntry, @required this.onClickedDone})
      : super(key: key);

  @override
  _CommandEntryDialogState createState() => _CommandEntryDialogState();
}

class _CommandEntryDialogState extends State<CommandEntryDialog> {
  final formKey = GlobalKey<FormState>();
  final experienceController = TextEditingController();

  DateTime _dateTime = DateTime.now();
  String _rating;

  List<String> topicOptions = [
    'Every Monday',
    'Every Tuesday',
    'Every Wednesday',
    'Every Thursday',
    'Every Friday',
    'Every Saturday',
    'Every Sunday',
  ];

  @override
  void dispose() {
    experienceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.commandEntry != null) {
      final commandEntryEdit = widget.commandEntry;

      experienceController.text = commandEntryEdit.command;
      _dateTime = commandEntryEdit.dateTime;
      _rating = commandEntryEdit.day;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _createAppBar(context),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                buildDate(),
                const SizedBox(height: 8),
                buildAnxiety(),
                const SizedBox(height: 8),
                buildExperienceField(),
                const SizedBox(height: 10),
                buildExperience(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createAppBar(BuildContext context) {
    final isEditing = widget.commandEntry != null;
    final title = isEditing ? 'Edit Command' : 'Add Command';
    return AppBar(
      title: Text(title),
      actions: [
        //buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildDate() => Card(
        child: ListTile(
          leading: Icon(Icons.today, color: Colors.grey[500]),
          title: DateTimeItem(
            dateTime: _dateTime,
            onChanged: (dateTime) => setState(() => _dateTime = dateTime),
          ),
        ),
      );

  Widget buildAnxiety() => Card(
        child: ListTile(
          leading: Icon(Icons.bar_chart, color: Colors.grey[500]),
          title: const Text('Repeat'),
          trailing: PopupMenuButton<String>(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                (_rating == null) ? 'Never' : _rating.toString(),
              ),
            ),
            onSelected: (String value) {
              setState(() {
                _rating = value;
              });
            },
            itemBuilder: (context) {
              return topicOptions.map<PopupMenuItem<String>>((String value) {
                return PopupMenuItem(
                    child: Text(value.toString()), value: value);
              }).toList();
            },
          ),
        ),
      );

  Widget buildExperienceField() => const Card(
        child: ListTile(
          leading: Text('1/3.',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15)),
          title: Text('Please enter a command or set of commands',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15)),
        ),
      );

  Widget buildExperience() => ListTile(
        leading: Icon(Icons.speaker_notes, color: Colors.grey[500]),
        title: TextFormField(
          minLines: 3,
          maxLines: 6,
          controller: experienceController,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: "e.g Turn the light on",
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
              suffixIcon: experienceController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () => experienceController.clear(),
                      icon: const Icon(Icons.clear))
                  : null),
          validator: (experience) => experience != null && experience.isEmpty
              ? 'Please a command'
              : null,
        ),
      );

  Widget buildAddButton(BuildContext context, {bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return ElevatedButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState.validate();

        if (isValid) {
          final command = experienceController.text;
          final day = _rating;
          final dateTime = _dateTime;

          widget.onClickedDone(
            dateTime,
            day,
            command,
          );

          Navigator.of(context).pop();
        }
      },
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
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: (() => _showDatePicker(context)),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
