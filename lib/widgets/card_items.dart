import 'package:flutter/material.dart';
import 'package:stress_app/utils/const.dart';

import 'custom_clipper.dart';

class CardItems extends StatelessWidget {
  final Image image;
  final String title;
  final String value;
  final String unit;
  final Color color;
  final int progress;

  const CardItems({
    this.image,
    this.title,
    this.value,
    this.unit,
    this.color,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 100,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Positioned(
            child: ClipPath(
              clipper: MyCustomClipper(clipType: ClipType.halfCircle),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  color: color.withOpacity(0.1),
                ),
                height: 100,
                width: 100,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Icon and Hearbeat
                image,
                const SizedBox(width: 30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$title',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Constants.textPrimary),
                          ),
                          Text(
                            '$value $unit',
                            style: TextStyle(
                                fontSize: 15, color: Constants.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      (progress == 0 || progress == null)
                          ? Text('Not started',
                              style: TextStyle(
                                  fontSize: 15, color: Constants.textPrimary))
                          : Container(
                              height: 6,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                shape: BoxShape.rectangle,
                                color: Color(0xFFD9E2EC),
                              ),
                              child: LayoutBuilder(builder:
                                  (BuildContext context,
                                      BoxConstraints constraints) {
                                return Stack(
                                  children: <Widget>[
                                    Positioned(
                                      left: 0,
                                      child: Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            shape: BoxShape.rectangle,
                                            color: Color(0xFF50DE89),
                                          ),
                                          width: constraints.maxWidth *
                                              (progress / 100),
                                          height: 6),
                                    )
                                  ],
                                );
                              }),
                            ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
