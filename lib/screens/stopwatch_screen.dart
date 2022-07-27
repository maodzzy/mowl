import 'package:MOWL/components/end_session.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../components/components.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../data/activity_model.dart';
import '../models/models.dart';
import 'dart:async';
import '../theme/appTheme.dart';
import 'history_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StartStopwathScreen extends StatefulWidget {
  const StartStopwathScreen({Key? key}) : super(key: key);

  static getData({key}) async {
    final perf = await SharedPreferences.getInstance();
    var data = perf.getInt(key);

    return data;
  }

  static setData({key, value}) async {
    final perf = await SharedPreferences.getInstance();
    var data = perf.setInt(key, value);

    return data;
  }

  @override
  _StartStopwathScreenState createState() => _StartStopwathScreenState();
}

class _StartStopwathScreenState extends State<StartStopwathScreen> {
  Duration currentDuration = const Duration(seconds: 0);
  int timerDuration = Duration.zero.inMilliseconds;
  late DateTime startTime;
  late DateTime timerRun;
  Timer? timer;
  int timerState = 0;
  String formattedStartTime = "";
  Box<ActivityModel> dataBox = Hive.box<ActivityModel>("data");

  @override
  void initState() {
    super.initState();
    initializeData();

    // if (timerState == 1) {
    //   startTimer();
    // } else if (timerState == 2) {
    //   // currentDuration = Duration(milliseconds: timerDuration);
    //   pauseTimer();
    // }
  }

  void initializeData() async {
    int intValue = await StartStopwathScreen.getData(key: 'timerState');
    int intDuration = await StartStopwathScreen.getData(key: 'timerDuration');
    int start = await StartStopwathScreen.getData(key: 'startTime');
    int timer = await StartStopwathScreen.getData(key: 'timerRun');

    setState(() {
      if (intValue != null) {
        timerState = intValue;
      }
      if (intDuration != null) {
        timerDuration = intDuration;
      }

      if (timerDuration != null) {
        currentDuration = Duration(milliseconds: timerDuration);
      }

      if (timer != null) {
        timerRun = DateTime.fromMillisecondsSinceEpoch(timer);
      } else {
        timerRun = DateTime.now();
      }
      if (start != null) {
        startTime = DateTime.fromMillisecondsSinceEpoch(start);
      } else {
        startTime = DateTime.now();
      }
      if (timerState == 1) {
        startTimer();
      } else if (timerState == 2) {
        // currentDuration = Duration(milliseconds: timerDuration);
        chooseWidget();
      }
    });
  }

  startTimer() {
    int addSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      addSeconds = DateTime.now().millisecondsSinceEpoch -
          startTime.millisecondsSinceEpoch +
          timerDuration;

      setState(() {
        int milliseconds = addSeconds;
        currentDuration = Duration(milliseconds: milliseconds);
        timerState = 1;
        StartStopwathScreen.setData(key: 'timerState', value: timerState);
        // chooseWidget();
      });
    });
  }

  void pauseTimer() {
    timer?.cancel();

    setState(() {
      timerDuration = timerDuration +
          DateTime.now().millisecondsSinceEpoch -
          startTime.millisecondsSinceEpoch;
      StartStopwathScreen.setData(key: 'timerDuration', value: timerDuration);
      startTime = DateTime.now();

      StartStopwathScreen.setData(
          key: 'startTime', value: startTime.millisecondsSinceEpoch);
      timerState = 2;
      StartStopwathScreen.setData(key: 'timerState', value: timerState);
    });
  }

  void stopTimer() {
    timer?.cancel();

    setState(() {
      currentDuration = const Duration(milliseconds: 0);
      timerDuration = 0;
      StartStopwathScreen.setData(key: 'timerDuration', value: timerDuration);

      timerState = 0;
      StartStopwathScreen.setData(key: 'timerState', value: timerState);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ApplicationTheme.mainColor,
      resizeToAvoidBottomInset: true,
      body: chooseWidget(),
    );
  }

  Widget chooseWidget() {
    if (timerState == 0) {
      return buildTimerStopped();
    } else if (timerState == 1) {
      return buildTimerStarted(currentDuration);
    } else if (timerState == 2) {
      return buildTimerPaused();
    } else {
      return Text(timerState.toString());
    }
  }

  Widget buildTimerStopped() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context).startSession,
              style: Theme.of(context).textTheme.bodyText1),
          const SizedBox(height: 10),
          Opacity(opacity: 0.3, child: BuildTime(duration: currentDuration)),
          const SizedBox(height: 10),
          PlayButton(onClicked: () {
            timerRun = DateTime.now();
            StartStopwathScreen.setData(
                key: 'timerRun', value: timerRun.millisecondsSinceEpoch);
            startTime = DateTime.now();
            StartStopwathScreen.setData(
                key: 'startTime', value: startTime.millisecondsSinceEpoch);
            startTimer();
          }),
          const SizedBox(height: 30)
        ],
      ),
    );
  }

  Widget buildTimerStarted(currentDuration) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BuildTime(duration: currentDuration),
          const SizedBox(height: 10),
          PauseButton(onClicked: () {
            pauseTimer();
          }),
        ],
      ),
    );
  }

  Widget buildTimerPaused() {
    formattedStartTime = DateFormat('yyyy-MM-dd  HH:mm').format(timerRun);
    var days = currentDuration.inDays;
    var hours = currentDuration.inHours.remainder(24);
    var minutes = currentDuration.inMinutes.remainder(60);
    var seconds = currentDuration.inSeconds.remainder(60);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextInform(
              startTime: formattedStartTime,
              days: days.toString(),
              hours: hours.toString(),
              minutes: minutes.toString(),
              seconds: seconds.toString()),
          BuildTime(duration: currentDuration),
          PlayButton(onClicked: () {
            if (DateTime.now()
                .subtract(const Duration(seconds: 2))
                .isAfter(startTime)) {
              print(startTime.difference(DateTime.now()));
              startTime = DateTime.now();
              startTimer();
            }

            /* timerRun = DateTime.now();
            StartStopwathScreen.setData(
                key: 'timerRun', value: timerRun.millisecondsSinceEpoch); */
          }),
          FlatButtonWidget(
              text: "${AppLocalizations.of(context).endSession}!",
              onPressed: () async {
                if (currentDuration > const Duration(minutes: 1)) {
                  final List current =
                      await Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (_, __, ___) => EndSessionModal(
                                startTime: startTime,
                                currentDuration: currentDuration,
                                timerState: timerState,
                                timerDuration: timerDuration,
                              )));

                  setState(() {
                    if (current != null) {
                      currentDuration = current[0];
                      timerDuration = current[1];
                      var zero = current[1];
                      timerState = zero;
                      StartStopwathScreen.setData(
                          key: 'timerState', value: timerState);
                    }
                  });
                } else {
                  await Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (_, __, ___) => shortSessionModal(),
                    ),
                  );
                }

                print(currentDuration);
              }),
        ],
      ),
    );
  }

  Widget shortSessionModal() {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.3),
      body: Center(
        child: Container(
          // color: ApplicationTheme.mainColor,
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: const BoxDecoration(
            color: ApplicationTheme.mainColor,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            border: Border(
              top: BorderSide(color: ApplicationTheme.lightColor),
              right: BorderSide(color: ApplicationTheme.lightColor),
              bottom: BorderSide(color: ApplicationTheme.lightColor),
              left: BorderSide(color: ApplicationTheme.lightColor),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.report_problem,
                size: 100,
                color: ApplicationTheme.lightColor,
              ),
              Text(
                AppLocalizations.of(context).shortSession,
                style: const TextStyle(
                  color: ApplicationTheme.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                AppLocalizations.of(context).sessionRecordRule1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: ApplicationTheme.black,
                  // textBaseline: TextBaseline.ideographic,
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              FlatButtonWidget(
                text: AppLocalizations.of(context).continueSession,
                onPressed: () {
                  // pauseTimer();
                  Navigator.pop(context);
                },
              ),
              FlatButtonWidget(
                text: AppLocalizations.of(context).endSessionWithoutSave,
                onPressed: () {
                  stopTimer();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}


/* 
RawAutocomplete(
    optionsBuilder: (TextEditingValue textEditingValue) {
      if (textEditingValue.text == '') {
        return const Iterable<String>.empty();
      }else{
          List<String> matches = <String>[];
          matches.addAll(suggestons);

          matches.retainWhere((s){
            return s.toLowerCase().contains(textEditingValue.text.toLowerCase());
          });
          return matches;
      }
    },

    onSelected: (String selection) {
        print('You just selected $selection');
    }, 

    fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted) {
          return TextField(
            decoration: InputDecoration(
               border: OutlineInputBorder()
            ),
            controller: textEditingController,
            focusNode: focusNode,
            onSubmitted: (String value) {
            
            },
          );
    },

    optionsViewBuilder: (BuildContext context, void Function(String) onSelected, 
                         Iterable<String> options) { 
        return Material(
          child:SizedBox(
            height: 200,
            child:SingleChildScrollView(
              child: Column(
                children: options.map((opt){
                  return InkWell(
                    onTap: (){
                       onSelected(opt);
                    },
                    child:Container(
                        padding: EdgeInsets.only(right:60),
                        child:Card(
                            child: Container( 
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              child:Text(opt),
                            )
                        )
                    )
                  );
                }).toList(),
              )
            )
          )
        );
    },
)
 */