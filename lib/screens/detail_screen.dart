import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:stress_app/utils/const.dart';
import 'package:stress_app/widgets/custom_clipper.dart';
import 'package:stress_app/widgets/grid_item.dart';
import 'package:stress_app/widgets/progress_vertical.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_clipper.dart';
import '../widgets/command_class.dart';
import '../widgets/command_entry_dialog.dart';
import '../widgets/command_list_item.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // method channel
  static const batteryChannel = MethodChannel("stress_app/battery");
  String batteryLevel = "0";
  int rating = 0;

  Timer timer;

  List<CommandEntry> commandSaves = [];
  final ScrollController _listViewScrollController = ScrollController();
  final double _itemExtent = 50.0;
  bool isSwitched = false;
  final FlutterTts flutterTts = FlutterTts();

  int level = 45;
  int heartLevel = 66;

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset(assetName, width: 100.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  void initState() {
    super.initState();
    listenBattery();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void listenBattery() {
    timer = Timer.periodic(
        const Duration(seconds: 5), (timer) async => getBatteryLevel());
  }

  // Communicating and calling native kotlin for the google assistant
  Future getBatteryLevel() async {
    final int newBatteryLevel =
        await batteryChannel.invokeMethod("getBatteryLevel");
    setState(() {
      batteryLevel = '$newBatteryLevel';
    });
    await Future.delayed(const Duration(seconds: 1));
    _speak();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    // For Grid Layout
    double _crossAxisSpacing = 16, _mainAxisSpacing = 16, _cellHeight = 150.0;
    int _crossAxisCount = 2;

    double _width = (MediaQuery.of(context).size.width -
            ((_crossAxisCount - 1) * _crossAxisSpacing)) /
        _crossAxisCount;
    double _aspectRatio =
        _width / (_cellHeight + _mainAxisSpacing + (_crossAxisCount + 1));

    List<int> stressLevels = [0, 30, 50, 30, 60, 40, 100];

    changeColor(int value) {
      if (stressLevels[6] <= 75) {
        return Colors.white;
      } else {
        return Colors.red;
      }
    }

    int batteryNew = 0;

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: MyCustomClipper(clipType: ClipType.bottom),
            child: Container(
              color: Constants.darkGreen,
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
              scrollDirection: Axis.vertical,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // Back Button
                        SizedBox(
                          width: 34,
                          child: RawMaterialButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back_ios,
                                size: 15.0, color: Colors.white),
                            shape: const CircleBorder(
                              side: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                  style: BorderStyle.solid),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "Nightmare",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              mainAxisAlignment: MainAxisAlignment.start,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  heartLevel.toString(),
                                  style: TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w900,
                                      color: changeColor(heartLevel)),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "bpm",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Image(
                        fit: BoxFit.cover,
                        image:
                            const AssetImage('assets/icons/heartbeatthin.png'),
                        height: 73,
                        width: 80,
                        color: Colors.white.withOpacity(1)),
                  ],
                ),
                const SizedBox(height: 30),
                // Chart
                Material(
                  shadowColor: Colors.grey.withOpacity(0.01), // added
                  type: MaterialType.card,
                  elevation: 10, borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    height: 210,
                    child: Column(
                      children: [
                        // Rest Active Legend
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Constants.lightGreen,
                                  shape: BoxShape.circle),
                            ),
                            const Text("Relax"),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Constants.darkGreen,
                                  shape: BoxShape.circle),
                            ),
                            const Text("Stress"),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                            ),
                            const Text("Nightmare"),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Main Cards - Heartbeat and Blood Pressure
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ProgressVertical(
                                value: stressLevels[0],
                                date: "1",
                                isShowDate: true,
                              ),
                              ProgressVertical(
                                value: stressLevels[1],
                                date: "2",
                                isShowDate: true,
                              ),
                              ProgressVertical(
                                value: stressLevels[2],
                                date: "3",
                                isShowDate: true,
                              ),
                              ProgressVertical(
                                value: stressLevels[3],
                                date: "4",
                                isShowDate: true,
                              ),
                              ProgressVertical(
                                value: stressLevels[4],
                                date: "5",
                                isShowDate: true,
                              ),
                              ProgressVertical(
                                value: stressLevels[5],
                                date: "6",
                                isShowDate: true,
                              ),
                              ProgressVertical(
                                value: stressLevels[6],
                                date: "7",
                                isShowDate: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Line Graph
                      ],
                    ),
                  ), // added
                ),

                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Rate your sleep: $rating',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      RatingBar.builder(
                          minRating: 1,
                          itemSize: 20,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          updateOnDrag: true,
                          itemBuilder: (context, _) =>
                              const Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) => setState(() {
                                this.rating = rating.round();
                              })),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              title: const Text('Share '),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _buildImage('assets/icons/doctor.jpg'),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                        "This will allow you to share your data with your doctor using secure connection with Google Health API. "),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.share),
                                        label: const Text('Share data')),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share sleep data')),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: (() {
                          getBatteryLevel();
                          setState(() {
                            stressLevels[6] = 90;
                            heartLevel = 120;
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: SizedBox(
                                      height: 40,
                                      child: Text(
                                          'Nightmare detected, activating respective command'),
                                    )));
                          });
                        }),
                        child: const Text("Simulate Trigger")),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: _openAddEntryDialog,
                          child: const Text("Enter a Google Home Command")),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Text(
                  "SCHEDULED ACTIVITIES",
                  style: TextStyle(
                      color: Constants.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  child: (commandSaves.isEmpty)
                      ? const SizedBox(
                          child: Text(
                              'Please Press the button above to Enter a Command'),
                          height: 40.0,
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          controller: _listViewScrollController,
                          itemCount: commandSaves.length,
                          itemBuilder: (buildContext, index) {
                            return InkWell(
                                onTap: () => _editEntry(commandSaves[index]),
                                child: Dismissible(
                                  key: Key(commandSaves[index].toString()),
                                  onDismissed: (direction) {
                                    setState(() {
                                      commandSaves.removeAt(index);
                                    });
                                  },
                                  child: CommandListItem(
                                      commandSaves[index], index + 1),
                                ));
                          },
                        ),
                ),

                const SizedBox(height: 30),
                Text('$batteryLevel'),
                Text(
                  "MORE",
                  style: TextStyle(
                      color: Constants.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount,
                    crossAxisSpacing: _crossAxisSpacing,
                    mainAxisSpacing: _mainAxisSpacing,
                    childAspectRatio: _aspectRatio,
                  ),
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    switch (index) {
                      case 0:
                        return GridItem(
                          status: "Participate in a study",
                          color: Constants.darkGreen,
                          image: "assets/icons/research.jpg",
                          title: "Research Study",
                          content:
                              "Read and join any of the ongoing studies listed below.",
                        );
                        break;
                      default:
                        return GridItem(
                          status: "Sleeping tips",
                          color: Constants.lightBlue,
                          image: "assets/icons/sleep.jpeg",
                          title: "Sleeping Tips",
                          content:
                              "Below are a list of tips to help you sleep better.",
                        );
                        break;
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addcommandSave(CommandEntry commandSave) {
    setState(() {
      commandSaves.add(commandSave);
      _listViewScrollController.animateTo(
        commandSaves.length * _itemExtent,
        duration: const Duration(microseconds: 1),
        curve: const ElasticInCurve(0.01),
      );
    });
  }

  // edit an already added google home command
  _editEntry(CommandEntry commandSave) {
    Navigator.of(context)
        .push(
      MaterialPageRoute<CommandEntry>(
        builder: (BuildContext context) {
          return CommandEntryDialog.edit(commandSave);
        },
        fullscreenDialog: true,
      ),
    )
        .then((newSave) {
      if (newSave != null) {
        setState(
            () => commandSaves[commandSaves.indexOf(commandSave)] = newSave);
      }
    });
  }

  // Add a google home command
  Future _openAddEntryDialog() async {
    CommandEntry save =
        await Navigator.of(context).push(MaterialPageRoute<CommandEntry>(
            builder: (BuildContext context) {
              return CommandEntryDialog.add(commandSaves.isNotEmpty
                  ? commandSaves.last.command
                  : 'Never');
            },
            fullscreenDialog: true));
    if (save != null) {
      _addcommandSave(save);
    }
  }

  // Text to Speech for the google assistant
  Future _speak() async {
    debugPrint(commandSaves[0].command);
    await flutterTts.speak(commandSaves[0].command);
  }
}
