import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../components/flat_button_widget.dart';
import '../components/icon_button_widget.dart';
import '../components/indicator.dart';
import '../data/activity_model.dart';
import '../theme/appTheme.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  Box<ActivityModel> dataBox = Hive.box<ActivityModel>("data");
  DateTime currentDate = DateTime.now();
//TODO: вынести в отдельный файл
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

  Color generateRandomColor(double precision) {
    // Pick a random number in the range [0.0, 1.0)

    return Color((precision * 0xFF0000 + 0xFF1111).toInt()).withOpacity(0.7);
  }

  List<ActivityChart> activityChart = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
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
        Align(
          alignment: Alignment.topCenter,
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
        Expanded(
            child: AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.3,
                      child: PieChart(
                        PieChartData(
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 3,
                            centerSpaceRadius: 60,
                            sections: showingSections()),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 1.3,
                      child: PieChart(
                        PieChartData(
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 3,
                            centerSpaceRadius: 47,
                            sections: showingSections2()),
                      ),
                    ),
                  ],
                ))),
        Expanded(
          child: ListView.builder(
              itemCount: activityChart.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Indicator(
                      color: generateRandomColor(index / activityChart.length),
                      text: activityChart[index].name,
                      description: activityChart[index].description,
                      isSquare: true,
                      duration: activityChart[index].duration,
                    ),
                    const SizedBox(height: 3),
                  ],
                );
              }),
        ),
      ],
    );
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

  List<PieChartSectionData> showingSections() {
    activityChart.clear();
    var dataBoxCurrentDay = dataBox.values
        .where((activity) => activity.start.day == currentDate.day);

    for (var activity in dataBoxCurrentDay) {
      bool trust = false;
      int index = 0;

      for (int j = 0; j < activityChart.length; j++) {
        if (activityChart[j].name.replaceAll(' ', '') ==
                activity.name.replaceAll(' ', '') &&
            activityChart[j].description.replaceAll(' ', '') ==
                activity.description.replaceAll(' ', '')) {
          trust = true;
          index = j;
          j++;
        } else {
          trust = false;
        }
      }

      if (trust) {
        activityChart[index].duration = Duration(
            milliseconds: activityChart[index].duration.inMilliseconds +
                activity.end.difference(activity.start).inMilliseconds);
      } else {
        activityChart.add(ActivityChart(
          name: activity.name,
          description: activity.description,
          duration: activity.end.difference(activity.start),
        ));
      }
    }
    List<PieChartSectionData> listChart = [];
    PieChartSectionData pieChart;
    List<ActivityChart> nameActivityChart = [];

    for (var activity in activityChart) {
      bool trust = false;
      int index = 0;
      // nameActivityChart.clear();
      // nameActivityChart.add(activity);

      for (int i = 0; i < nameActivityChart.length; i++) {
        if (nameActivityChart[i].name.replaceAll(' ', '') ==
            activity.name.replaceAll(' ', '')) {
          trust = true;
          index = i;
        } else {
          trust = false;
        }
      }
      if (trust) {
        nameActivityChart[index].duration = Duration(
            milliseconds: nameActivityChart[index].duration.inMilliseconds +
                activity.duration.inMilliseconds);
      } else {
        nameActivityChart.add(activity);
      }
    }

    // return List.generate(activityChart.length, (i) {

    const fontSize = 25.0;
    const radius = 20.0;
    if (activityChart.isNotEmpty) {
      for (int i = 0; i < nameActivityChart.length; i++) {
        pieChart = PieChartSectionData(
          color: generateRandomColor(i / activityChart.length),
          // showTitle: false,
          borderSide: BorderSide(),
          value: nameActivityChart[i].duration.inMinutes.toDouble(),
          titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black),
          title: nameActivityChart[i].name,
          radius: radius,
        );
        print(
            'pie1 = ${nameActivityChart[i].name} = ${nameActivityChart[i].duration.inMinutes.toString()}');
        listChart.add(pieChart);
      }
    } else {
      pieChart = PieChartSectionData(
        color: const Color(0xff0293ee),
        value: 40,
        title: '40%',
        radius: radius,
        titleStyle: const TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff)),
      );
      listChart.add(pieChart);
    }
    return listChart;
  }

  List<PieChartSectionData> showingSections2() {
    List<PieChartSectionData> listChart = [];

    PieChartSectionData pieChart2;
    // return List.generate(activityChart.length, (i) {

    const fontSize = 25.0;
    const radius = 20.0;
    if (activityChart.isNotEmpty) {
      for (int i = 0; i < activityChart.length; i++) {
        pieChart2 = PieChartSectionData(
          color: generateRandomColor(i / activityChart.length),
          // showTitle: false,
          borderSide: BorderSide(),
          value: activityChart[i].duration.inMinutes.toDouble(),
          titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black),
          title: activityChart[i].description,
          radius: radius / 2,
        );
        print(
            'pie2 = ${activityChart[i].description} = ${activityChart[i].duration.inMinutes.toString()}');

        listChart.add(pieChart2);
      }
    } else {
      pieChart2 = PieChartSectionData(
        color: const Color(0xff0293ee),
        value: 40,
        title: '40%',
        radius: radius,
        titleStyle: const TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff)),
      );
      listChart.add(pieChart2);
    }
    return listChart;
  }
}

class ActivityChart {
  String name;
  String description;
  Duration duration;

  ActivityChart({
    required this.name,
    required this.description,
    required this.duration,
  });
}
