import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stress_app/utils/const.dart';
import 'package:flutter/services.dart';
import '../widgets/card_main.dart';
import '../widgets/custom_clipper.dart';
import '../widgets/situation_class.dart';
import '../widgets/situation_entry_dialog.dart';
import '../widgets/situation_list_item.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // method channel
  static const batteryChannel = MethodChannel("stress_app/battery");
  String batteryLevel = "wait";

  List<WeightEntry> weightSaves = [];
  final ScrollController _listViewScrollController = ScrollController();
  final double _itemExtent = 50.0;
  bool isSwitched = false;
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Stack(
        children: [
          ClipPath(
            clipper: MyCustomClipper(clipType: ClipType.bottom),
            child: Container(
              color: Theme.of(context).colorScheme.onSecondary,
              height: Constants.headerHeight + statusBarHeight,
            ),
          ),
          Positioned(
            right: -45,
            top: -30,
            child: ClipOval(
              child: Container(
                color: Colors.black.withOpacity(0.05),
                height: 220,
                width: 220,
              ),
            ),
          ),

          // BODY
          Padding(
            padding: EdgeInsets.all(Constants.paddingSide),
            child: ListView(
              children: [
                // Header - Greetings and Avatar
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        "Good Morning,\nPatient",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ),
                    CircleAvatar(
                        radius: 26.0,
                        backgroundImage:
                            AssetImage('assets/icons/profile_picture.png'))
                  ],
                ),

                const SizedBox(height: 50),

                // Main Cards - Heartbeat and Blood Pressure
                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      CardMain(
                        image: const AssetImage('assets/icons/heartbeat.png'),
                        title: "Heartbeat",
                        value: "66",
                        unit: "bpm",
                        color: Constants.lightGreen,
                      ),
                      CardMain(
                          image: const AssetImage('assets/icons/blooddrop.png'),
                          title: "Blood Pressure",
                          value: "66/123",
                          unit: "mmHg",
                          color: Constants.lightYellow)
                      //Something to check hyperventilation
                    ],
                  ),
                ),

                // Section Cards - Daily Medication
                const SizedBox(height: 50),
                // Scheduled Activities
                Text(
                  "SCHEDULED ACTIVITIES",
                  style: TextStyle(
                      color: Constants.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),

                Text(
                  batteryLevel,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                ElevatedButton(
                    onPressed: getBatteryLevel,
                    child: const Text("get Battery Level")),

                const SizedBox(height: 20),
                Container(
                  child: (weightSaves.isEmpty)
                      ? const SizedBox(
                          child: Text(
                              'Please Press the + button to Enter a Command'),
                          height: 40.0,
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          controller: _listViewScrollController,
                          itemCount: weightSaves.length,
                          itemBuilder: (buildContext, index) {
                            return InkWell(
                                onTap: () => _editEntry(weightSaves[index]),
                                child: WeightListItem(weightSaves[index]));
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton.icon(
        label: const Text('Add Command'),
        icon: const Icon(Icons.add),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue, // background
          onPrimary: Colors.white, // foreground
        ),
        onPressed: _openAddEntryDialog,
      ),
    );
  }

  void _addWeightSave(WeightEntry weightSave) {
    setState(() {
      weightSaves.add(weightSave);
      _listViewScrollController.animateTo(
        weightSaves.length * _itemExtent,
        duration: const Duration(microseconds: 1),
        curve: const ElasticInCurve(0.01),
      );
    });
  }

  _editEntry(WeightEntry weightSave) {
    Navigator.of(context)
        .push(
      MaterialPageRoute<WeightEntry>(
        builder: (BuildContext context) {
          return WeightEntryDialog.edit(weightSave);
        },
        fullscreenDialog: true,
      ),
    )
        .then((newSave) {
      if (newSave != null) {
        setState(() => weightSaves[weightSaves.indexOf(weightSave)] = newSave);
      }
    });
  }

  Future _openAddEntryDialog() async {
    WeightEntry save =
        await Navigator.of(context).push(MaterialPageRoute<WeightEntry>(
            builder: (BuildContext context) {
              return WeightEntryDialog.add(
                  weightSaves.isNotEmpty ? weightSaves.last.weight : 0);
            },
            fullscreenDialog: true));
    if (save != null) {
      _addWeightSave(save);
    }
  }

  Future getBatteryLevel() async {
    final int newBatteryLevel =
        await batteryChannel.invokeMethod("getBatteryLevel");
    setState(() {
      batteryLevel = '$newBatteryLevel';
    });
    await Future.delayed(Duration(seconds: 1));
    _speak();
  }

  Future _speak() async {
    await flutterTts.speak("trun lights off and turn room on");
  }
}
