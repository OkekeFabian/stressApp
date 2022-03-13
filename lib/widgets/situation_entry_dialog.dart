import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';
import 'package:meta/meta.dart';

import 'situation_class.dart';

class WeightEntryDialog extends StatefulWidget {
  final int initialWeight;
  final WeightEntry weighEntryToEdit;

  WeightEntryDialog.add(this.initialWeight) : weighEntryToEdit = null;

  WeightEntryDialog.edit(this.weighEntryToEdit)
      : initialWeight = weighEntryToEdit.weight;

  @override
  // ignore: no_logic_in_create_state
  WeightEntryDialogState createState() {
    if (weighEntryToEdit != null) {
      return WeightEntryDialogState(
          weighEntryToEdit.dateTime,
          weighEntryToEdit.weight,
          weighEntryToEdit.note,
          weighEntryToEdit.note2,
          weighEntryToEdit.note3);
    } else {
      return WeightEntryDialogState(
          DateTime.now(), initialWeight, null, null, null);
    }
  }
}

class WeightEntryDialogState extends State<WeightEntryDialog> {
  DateTime _dateTime = DateTime.now();
  int _weight;
  String _note;
  String _note2;
  String _note3;

  TextEditingController _textController;
  TextEditingController _textController2;
  TextEditingController _textController3;

  List<String> topicOptions = [
    'Every Monday',
    'Every Tuesday',
    'Every Wednesday',
    'Every Thursday',
    'Every Friday',
    'Every Saturday',
    'Every Sunday',
  ];

  WeightEntryDialogState(
      this._dateTime, this._weight, this._note, this._note2, this._note3);

  Widget _createAppBar(BuildContext context) {
    return AppBar(
      title: widget.weighEntryToEdit == null
          ? const Text("New entry")
          : const Text("Edit entry"),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .pop(WeightEntry(_dateTime, _weight, _note, _note2, _note3));
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
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _note);
    _textController2 = TextEditingController(text: _note2);
    _textController3 = TextEditingController(text: _note3);
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
                        _weight.toString(),
                      ),
                    ),
                    onSelected: (String value) {
                      _weight = int.parse(value);
                    },
                    itemBuilder: (context) {
                      return topicOptions
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
                title: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 2,
                  decoration: const InputDecoration(
                    hintText: """ e.g Turn on the Light for 20 minutes""",
                  ),
                  controller: _textController2,
                  onChanged: (value) => _note2 = value,
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
      children: <Widget>[
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