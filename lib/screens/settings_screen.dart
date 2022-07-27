import '../l10n/language_constants.dart';
import '../main.dart';
import '../theme/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<DropdownMenuItem<Locale>> get dropdownItems {
    List<DropdownMenuItem<Locale>> menuItems = [
      DropdownMenuItem(
          child: Text(AppLocalizations.of(context).english),
          value: const Locale("en", 'US')),
      DropdownMenuItem(
          child: Text(AppLocalizations.of(context).russian),
          value: const Locale("ru", 'RU')),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    Locale _selectedValue = Localizations.localeOf(context);
    return Center(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    AppLocalizations.of(context).chooseLanguage,
                    style: GoogleFonts.lato(
                        fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: ApplicationTheme.secondColor, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: ApplicationTheme.secondColor, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: ApplicationTheme.lightColor,
                      ),
                      dropdownColor: ApplicationTheme.lightColor,
                      value: _selectedValue,
                      onChanged: (Locale? newValue) {
                        setState(() {
                          if (_selectedValue != newValue) {
                            _selectedValue = newValue!;
                            LifeLoggerApp.setLocale(context, _selectedValue);
                            setLocale(_selectedValue.languageCode);
                          }
                          print(_selectedValue);
                        });
                      },
                      items: dropdownItems),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
