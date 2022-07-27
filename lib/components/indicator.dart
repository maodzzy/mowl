import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'duration_view.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;
  final Duration duration;
  final String description;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    required this.duration,
    required this.description,
    this.size = 16,
    this.textColor = const Color.fromARGB(255, 255, 255, 255),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final days = duration.inDays.toString();
    final hours = duration.inHours.remainder(24).toString();
    final minutes = duration.inMinutes.remainder(60).toString();
    final seconds = duration.inSeconds.remainder(60).toString();
    final durationText = DurationView.dur(days, hours, minutes, seconds);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        // width: size,
        // height: size,
        decoration: BoxDecoration(
          // shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
          color: color,
          border: Border.all(color: color, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '$text  $description',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                durationText,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
