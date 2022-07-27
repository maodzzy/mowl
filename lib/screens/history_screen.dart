import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../data/activity_model.dart';
import '../theme/appTheme.dart';
import 'activity_edit_screen.dart';
import 'stopwatch_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Box<ActivityModel> dataBox = ActivityModel.dataBox;
  final dayMonthFormater = DateFormat('MMM dd, EEEE');

  DateTime currentDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch:
                  const MaterialColor(0xFFFFC027, ApplicationTheme.colorCodes),
            ),
            dialogBackgroundColor: ApplicationTheme.mainColor,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }

  void _decreaseDate() {
    setState(() {
      currentDate = currentDate.subtract(const Duration(days: 1));
    });
  }

  void _increaseDate() {
    setState(() {
      currentDate = currentDate.add(const Duration(days: 1));
    });
  }

  void callback() {
    setState(() {
      print('Callback_history_screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    int key;
    List<int> keys = dataBox.keys.cast<int>().toList();
    ActivityModel activity;
    @override
    void initState() {
      super.initState();
    }

    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: dataBox.listenable(),
          builder: (context, Box<ActivityModel> items, _) {
            var keyIterable = items.keys.where((key) {
              return dataBox.get(key)?.start.day == currentDate.day;
            });
            List<ActivityModel> viewList = [];
            for (var i = 0; i < keyIterable.length; i++) {
              key = keyIterable.elementAt(i);
              activity = items.get(key)!;
              viewList.add(activity);
            }
            viewList
                .sort((first, second) => first.start.compareTo(second.start));
            return ListView.builder(
              padding: const EdgeInsets.only(top: 100),
              itemCount: viewList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                activity = viewList[index];

                var key = dataBox.keys
                    .firstWhere((element) => dataBox.get(element) == activity);

                return Dismissible(
                  key: ValueKey(activity),
                  /* background: Container(
                    color: ApplicationTheme.secondColor,
                    alignment: Alignment.centerLeft,
                    child: const Icon(Icons.delete),
                  ), */
                  onDismissed: (direction) async {
                    setState(() {
                      dataBox.delete(key);
                    });
                  },
                  background: Container(
                    color: ApplicationTheme.mainColor,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          const Icon(Icons.delete,
                              color: ApplicationTheme.secondColor),
                          Text(AppLocalizations.of(context).deleteActivity,
                              style: const TextStyle(
                                  color: ApplicationTheme.secondColor)),
                        ],
                      ),
                    ),
                  ),
                  direction: DismissDirection.startToEnd,
                  confirmDismiss: (DismissDirection direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Confirmation"),
                          content: const Text(
                              "Are you sure you want to delete this item?"),
                          actions: <Widget>[
                            FlatButtonWidget(
                              onPressed: () => Navigator.of(context).pop(true),
                              text: 'Delete',
                            ),
                            FlatButtonWidget(
                              onPressed: () => Navigator.of(context).pop(false),
                              text: 'Cancel',
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: GestureDetector(
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  ActivityEditScreen(newitem: activity)),
                        );
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: ActivityTile(
                          item: activity,
                        ),
                      )),
                );
              },
            );
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Text(
              AppLocalizations.of(context).date(currentDate),
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                backgroundColor: ApplicationTheme.mainColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: IconButtonWidget(
                  onClicked: () => _decreaseDate(),
                  color: ApplicationTheme.secondColor,
                  iconSize: 20,
                  icon: const Icon(Icons.arrow_back_ios_new_outlined),
                ),
              ),
              Expanded(
                flex: 2,
                child: FlatButtonWidget(
                  text: AppLocalizations.of(context).selectDate,
                  onPressed: () => _selectDate(context),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButtonWidget(
                  onClicked: () => _increaseDate(),
                  color: ApplicationTheme.secondColor,
                  iconSize: 20,
                  icon: const Icon(Icons.arrow_forward_ios_outlined),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              foregroundColor: ApplicationTheme.mainColor,
              focusColor: ApplicationTheme.mainColor,
              backgroundColor: ApplicationTheme.secondColor,
              onPressed: () async {
                var added = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ActivityEditScreen(
                            currentDate: currentDate,
                          )),
                );
                if (added != null) {
                  setState(() {
                    if (added[0] == true) {
                      dataBox.add(added[1]);
                    }
                  });
                }
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSeparator() {
    return Column(
      children: [
        const SizedBox(height: 5.0),
        Container(
          height: 2,
          color: Colors.black,
        ),
        const SizedBox(height: 5.0),
      ],
    );
  }
}
