import 'package:flutter/material.dart';
import 'package:stress_app/screens/detail_screen.dart';
import 'package:stress_app/utils/const.dart';

import 'custom_clipper.dart';

class CardMain extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String value;
  final String unit;
  final Color color;

  const CardMain({this.image, this.title, this.value, this.unit, this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        width: ((MediaQuery.of(context).size.width -
                (Constants.paddingSide * 2 + Constants.paddingSide / 2)) /
            2),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          shape: BoxShape.rectangle,
          color: color,
        ),
        child: Material(
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: Stack(
              children: [
                Positioned(
                  child: ClipPath(
                    clipper: MyCustomClipper(clipType: ClipType.semiCircle),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        color: Colors.black.withOpacity(0.03),
                      ),
                      height: 120,
                      width: 120,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon and Hearbeat
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(width: 35, height: 35, image: image),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 13, color: Constants.textDark),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Constants.textDark,
                        ),
                      ),
                      Text(
                        unit,
                        style:
                            TextStyle(fontSize: 15, color: Constants.textDark),
                      ),
                    ],
                  ),
                )
              ],
            ),
            onTap: () {
              debugPrint("CARD main clicked. redirect to details page");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DetailScreen()),
              );
            },
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }
}
