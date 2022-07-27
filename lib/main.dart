import 'package:MOWL/theme/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'l10n/language_constants.dart';
import 'models/models.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'data/activity_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'l10n/localization.dart';
import 'provider/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(ActivityModelAdapter());
  await Hive.openBox<ActivityModel>("data");

  runApp(const LifeLoggerApp());
}

class LifeLoggerApp extends StatefulWidget {
  const LifeLoggerApp({Key? key}) : super(key: key);
  static void setLocale(BuildContext context, Locale newLocale) {
    _LifeLoggerAppState? state =
        context.findAncestorStateOfType<_LifeLoggerAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<LifeLoggerApp> createState() => _LifeLoggerAppState();
}

class _LifeLoggerAppState extends State<LifeLoggerApp> {
  late Locale _locale = const Locale('ru', 'RU');
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    /*  Future<String> localeCountryCode = getString(key: 'locale');
    localeCountryCode.then((value) {
      if (value.isNotEmpty) {
        locale = Locale(value);
      } else {
        locale = Localizations.localeOf(context);
      }
    }); */
    if (this._locale == null) {
      return Container(
        child: const Center(
          child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(ApplicationTheme.mainColor)),
        ),
      );
    } else {
      return ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          return Consumer<LocaleProvider>(
            builder: (context, provider, child) {
              return MaterialApp(
                home: MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (context) => TabManager())
                  ],
                  child: const Home(),
                ),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('ru', 'RU'),
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale?.languageCode &&
                        supportedLocale.countryCode == locale?.countryCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                locale: _locale,
                /* routes: {
          '/': (context) => Home.pages[0],
          '/history_screen': (context) => Home.pages[1],
        }, */
              );
            },
          );
        },
      );
    }
  }
}


//important
//TODO 1: sharedPreferences put to own file
//unimportant
// TODO 1: set up an analytics tool, for example countly (https://pub.dev/packages/countly_flutter/example), https://support.count.ly/hc/en-us/articles/360037814511

