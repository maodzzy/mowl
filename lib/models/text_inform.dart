import '../components/duration_view.dart';
import 'package:flutter/material.dart';
import '../theme/appTheme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextInform extends StatelessWidget {
  final String startTime;
  final String hours;
  final String minutes;
  final String seconds;
  final String days;

  const TextInform({
    Key? key,
    required this.days,
    required this.startTime,
    required this.hours,
    required this.minutes,
    required this.seconds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String duration = DurationView.dur(days, hours, minutes, seconds);
    return Column(
      children: [
        Text(
          '${AppLocalizations.of(context).duration}: $duration',
          style: const TextStyle(
            color: ApplicationTheme.black,
          ),
          overflow: TextOverflow.clip,
        ),
        Text(
          '${AppLocalizations.of(context).startedAt}: $startTime',
          style: const TextStyle(
            color: ApplicationTheme.black,
          ),
        )
      ],
    );
  }
}
