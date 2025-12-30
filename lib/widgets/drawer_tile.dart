import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import '../utils/style/constants.dart';
import 'commonText.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    Key? key,
    required this.tileIcon,
    required this.tileName,
    required this.tileFunction,
  }) : super(key: key);

  final String tileIcon;
  final String tileName;
  final Function() tileFunction;

  @override
  Widget build(BuildContext context) {
    String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
    return Bounce(
      onPressed: tileFunction,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        // color: Colors.red,
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/images/appbar_icons/$tileIcon.png",
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                        'assets/images/appbar_icons/my bookings.png',
                        height: 25,
                        width: 25,
                        color: kWhite);
                  },
                  height: 25,
                  width: 25,
                  color: kWhite,
                ),
              ],
            ),
            const SizedBox(
              width: 22,
            ),
            Row(
              children: [
                commonText(
                  text: capitalize(tileName),
                  color: kWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                if (capitalize(tileName) == "Become a host" ||
                    capitalize(tileName) == "Become an agent") ...{
                  const SizedBox(
                    width: 12,
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: const Text(
                      'AD',
                      style: TextStyle(
                          fontSize: 6,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                }
              ],
            )
          ],
        ),
      ),
    );
  }
}
