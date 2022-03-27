import 'package:flutter/material.dart';
import 'package:stress_app/utils/const.dart';
import '../widgets/card_main.dart';
import '../widgets/card_section.dart';
import '../widgets/custom_clipper.dart';
import 'detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSwitched = false;

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
              color: Colors.blueAccent,
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
                Text(
                  "Features",
                  style: TextStyle(
                      color: Constants.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                SizedBox(
                    height: 125,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: () {
                            debugPrint(
                                "CARD main clicked. redirect to details page");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DetailScreen()),
                            );
                          },
                          child: CardSection(
                            image: AssetImage('assets/icons/capsule.png'),
                            title: "Nightmare",
                            time: "6-7AM",
                            isDone: false,
                          ),
                        ),
                        CardSection(
                          image: AssetImage('assets/icons/capsule.png'),
                          title: "Stress Relief",
                          time: "6-7AM",
                          isDone: false,
                        ),
                        CardSection(
                          image: AssetImage('assets/icons/syringe.png'),
                          title: "Hand-washing",
                          time: "8-9AM",
                          isDone: true,
                        ),
                        CardSection(
                          image: const AssetImage('assets/icons/syringe.png'),
                          title: "Breathing",
                          time: "8-9AM",
                          isDone: true,
                        ),
                        CardSection(
                          image: const AssetImage('assets/icons/syringe.png'),
                          title: "Mood doctor",
                          time: "8-9AM",
                          isDone: true,
                        ),
                        CardSection(
                          image: AssetImage('assets/icons/capsule.png'),
                          title: "Sitting Session",
                          time: "6-7AM",
                          isDone: false,
                        ),
                        CardSection(
                          image: AssetImage('assets/icons/capsule.png'),
                          title: "Morning Motivation",
                          time: "6-7AM",
                          isDone: false,
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
