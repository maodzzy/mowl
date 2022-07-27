import '../screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'screens/reports_screen.dart';
import 'theme/appTheme.dart';
import 'screens/stopwatch_screen.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';
import 'screens/history_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static List<Widget> pages = <Widget>[
    const StartStopwathScreen(),
    const HistoryScreen(),
    const ReportsScreen(),
    const SettingsScreen(),
    // Container(
    //   color: Colors.orangeAccent,
    // )
  ];

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TabManager>(builder: (context, tabManager, child) {
      return Scaffold(
        body: Home.pages[tabManager.selectedTab],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: ApplicationTheme.secondColor,
          unselectedItemColor: ApplicationTheme.inactiveColor,
          currentIndex: tabManager.selectedTab,
          enableFeedback: true,
          onTap: (index) {
            tabManager.goToTab(index);
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.timer),
              label: AppLocalizations.of(context).timer,
              backgroundColor: ApplicationTheme.mainColor,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history_edu),
              label: AppLocalizations.of(context).history,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.insert_chart_outlined),
              label: AppLocalizations.of(context).charts,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.tune),
              label: AppLocalizations.of(context).settings,
            )
          ],
        ),
      );
    });
  }
}
