import 'package:hive/hive.dart';

// Class for the command window

@HiveType(typeId: 0)
class CommandEntry {
  DateTime dateTime;

  String day;

  String command;

  CommandEntry(this.dateTime, this.day, this.command);
}
