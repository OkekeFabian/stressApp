import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/register.dart';
import 'utils/const.dart';
import 'package:firebase_core/firebase_core.dart';

import 'widgets/command_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      debugShowCheckedModeBanner: false,
      home: RegisterScreen()
      //const HomePage()
      ,
    );
  }
}
