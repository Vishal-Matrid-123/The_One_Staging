import 'package:flutter/material.dart';

Widget ProductBanner() {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage('MyAssets/top-background.png'),
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(42.0),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              'LIVING ROOM FURNITURE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Container(
                    width: 30,
                    margin: const EdgeInsets.only(right: 5.0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.white,
                      height: 10,
                    )),
                Text(
                  'LIVING ROOM FURNITURE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                new Container(
                    width: 30,
                    margin: const EdgeInsets.only(
                      left: 5.0,
                    ),
                    child: Divider(
                      thickness: 2,
                      color: Colors.white,
                      height: 10,
                    )),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
