import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/appTheme.dart';
import '../data/activity_model.dart';
import 'duration_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityTile extends StatefulWidget {
  final ActivityModel item;
  final bool deleteIcon;

  const ActivityTile({Key? key, required this.item, this.deleteIcon = true})
      : super(key: key);

  @override
  State<ActivityTile> createState() => _ActivityTileState();
}

class _ActivityTileState extends State<ActivityTile> {
  final dateFormatter = DateFormat('MMMM dd hh:mm');
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(
        top: 5,
        left: 5,
        right: 5,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: ApplicationTheme.mainColor,
          border: Border.all(color: ApplicationTheme.secondColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          /* boxShadow: const [
            BoxShadow(
              color: ApplicationTheme.secondColor,
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ], */
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name,
                      style: GoogleFonts.lato(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.item.description,
                      style: GoogleFonts.lato(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        '${AppLocalizations.of(context).dateTime(widget.item.start)} ${AppLocalizations.of(context).to} ${AppLocalizations.of(context).dateTime(widget.item.end)}'),
                  ]),
            ),
            Expanded(
              flex: 1,
              child: Center(child: buildDuration()),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDuration() {
    final duration = widget.item.end.difference(widget.item.start);
    final days = duration.inDays.toString();
    final hours = duration.inHours.remainder(24).toString();
    final minutes = duration.inMinutes.remainder(60).toString();
    final seconds = duration.inSeconds.remainder(60).toString();
    final durationText = DurationView.dur(days, hours, minutes, seconds);

    return Text(
      durationText,
      style: GoogleFonts.lato(
        fontSize: 15.0,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
