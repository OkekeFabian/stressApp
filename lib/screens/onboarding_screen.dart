import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final pageDecoration = const PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    bodyTextStyle: TextStyle(fontSize: 19.0),
    descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    pageColor: Colors.white,
    imagePadding: EdgeInsets.zero,
  );

  const OnboardingScreen({Key key}) : super(key: key);

  // to add LottieFIles
  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset(assetName, width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "About Xtrinsic",
          body:
              "A smart app that would adapt your environment to your needs. Using a wearable Device and the power of Google AI we try to detect and help you get through your struggles throughout the day and night",
          image: _buildImage("assets/icons/Xtrinsic.jpg"),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "How to Use",
          body:
              "You pick one of the features and then enter the set of google commands stored to your google home to assign to the features so they can be triggered in due time",
          image: Center(child: Image.asset("assets/icons/howto.png")),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
