import 'package:flutter/material.dart';

import 'package:stress_app/utils/const.dart';

class GridItem extends StatelessWidget {
  final String status;
  final String title;
  final String content;
  final String image;
  final Color color;

  const GridItem({
    Key key,
    this.status,
    this.title,
    this.content,
    this.image,
    this.color,
  }) : super(key: key);

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset(assetName, width: 120.0),
      alignment: Alignment.bottomCenter,
    );
  }

  Future _popUp(context, String title, String content) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            title: Text(title),
            content: Column(
              children: [
                Text(content),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
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
                      style:
                          TextStyle(fontSize: 12, color: Constants.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildImage(image),
                  ],
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          _popUp(context, title, content);
        });
  }
}
