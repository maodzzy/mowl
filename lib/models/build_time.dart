import 'package:flutter/material.dart';
import '../theme/appTheme.dart';

class BuildTime extends StatelessWidget {
  Duration duration = const Duration();
  BuildTime({Key? key, required this.duration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final days = twoDigits(duration.inDays);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (days != '00') buildTimeCard(time: days),
        const SizedBox(width: 10),
        buildTimeCard(time: hours),
        const SizedBox(width: 10),
        buildTimeCard(time: minutes),
        const SizedBox(width: 5),
        buildTimeCard(time: seconds, size: 25.0, padding: 7),
      ],
    );
  }

  Widget buildTimeCard(
          {required String time,
          double size = 50.0,
          Color color = ApplicationTheme.secondColor,
          double padding = 0.0}) =>
      Padding(
        padding: EdgeInsets.only(bottom: padding),
        child: Text(
          time,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: size,
          ),
        ),
      );
}
