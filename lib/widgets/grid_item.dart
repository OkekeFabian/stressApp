import 'package:flutter/material.dart';

import 'package:stress_app/utils/const.dart';

class GridItem extends StatelessWidget {
  final String status;
  final String time;
  final String value;
  final String unit;
  final ImageProvider image;
  final Color color;
  final String remarks;

  GridItem({
    this.status,
    this.value,
    this.unit,
    this.time,
    this.image,
    this.remarks,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status,
                  style: TextStyle(fontSize: 12, color: Constants.textPrimary),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            (image == null)
                ? Column(
                    children: <Widget>[
                      Text(
                        value,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 35,
                            color: color),
                      ),
                      Text(
                        unit,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image(
                        image: image,
                      ),
                      Text(
                        remarks,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
