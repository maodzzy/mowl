import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/activity_model.dart';
import '../screens/stopwatch_screen.dart';
import '../theme/appTheme.dart';
import 'flat_button_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EndSessionModal extends StatefulWidget {
  DateTime startTime;
  Duration currentDuration;
  int timerState;
  int timerDuration;
  EndSessionModal(
      {Key? key,
      required this.startTime,
      required this.currentDuration,
      required this.timerState,
      required this.timerDuration})
      : super(key: key);

  @override
  State<EndSessionModal> createState() => _EndSessionModalState();
}

class _EndSessionModalState extends State<EndSessionModal> {
  Box<ActivityModel> dataBox = Hive.box<ActivityModel>("data");

  final _nameActivity = TextEditingController();

  final _descriptionActivity = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _suggestionNameKey = UniqueKey();

  final _suggestionDescriptionKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.3),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: Container(
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
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RawAutocomplete(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          } else {
                            List<String> matches = <String>[];
                            matches.addAll(suggestionName());

                            matches.retainWhere((s) {
                              return s.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase());
                            });
                            return matches;
                          }
                        },
                        onSelected: (String selection) {
                          print('You just selected $selection');
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context).enterText;
                              }
                              return null;
                            },
                            key: _suggestionNameKey,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            controller: textEditingController,
                            focusNode: focusNode,
                            onChanged: (String value) {
                              _nameActivity.text = textEditingController.text;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          );
                        },
                        optionsViewBuilder: (BuildContext context,
                            void Function(String) onSelected,
                            Iterable<String> options) {
                          return Material(
                              child: SizedBox(
                                  height: 200,
                                  child: SingleChildScrollView(
                                      child: Column(
                                    children: options.map((opt) {
                                      return InkWell(
                                          onTap: () {
                                            onSelected(opt);
                                          },
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  right: 60),
                                              child: Card(
                                                  child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(opt),
                                              ))));
                                    }).toList(),
                                  ))));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RawAutocomplete(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          } else {
                            List<String> matches = <String>[];
                            matches.addAll(suggestionDescription());

                            matches.retainWhere((s) {
                              return s.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase());
                            });
                            return matches;
                          }
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context).enterText;
                              }
                              return null;
                            },
                            key: _suggestionDescriptionKey,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            controller: textEditingController,
                            focusNode: focusNode,
                            onChanged: (String value) {
                              _descriptionActivity.text =
                                  textEditingController.text;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          );
                        },
                        optionsViewBuilder: (BuildContext context,
                            void Function(String) onSelected,
                            Iterable<String> options) {
                          return Material(
                              child: SizedBox(
                                  height: 200,
                                  child: SingleChildScrollView(
                                      child: Column(
                                    children: options.map((opt) {
                                      return InkWell(
                                          onTap: () {
                                            onSelected(opt);
                                          },
                                          child: Container(
                                              padding: const EdgeInsets.only(
                                                  right: 60),
                                              child: Card(
                                                  child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(opt),
                                              ))));
                                    }).toList(),
                                  ))));
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FlatButtonWidget(
                      text: AppLocalizations.of(context).endSession,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final String name = _nameActivity.text;
                          final String description = _descriptionActivity.text;
                          _nameActivity.clear();
                          _descriptionActivity.clear();
                          ActivityModel data = ActivityModel(
                              name: name,
                              description: description,
                              start: widget.startTime,
                              end: DateTime.now());
                          widget.currentDuration = Duration.zero;
                          widget.timerState = 0;
                          widget.timerDuration = 0;
                          widget.startTime = DateTime(0);
                          StartStopwathScreen.setData(
                              key: 'timerState', value: widget.timerState);
                          StartStopwathScreen.setData(
                              key: 'timerDuration',
                              value: widget.timerDuration);
                          StartStopwathScreen.setData(
                              key: 'startTime',
                              value: widget.startTime.millisecondsSinceEpoch);

                          dataBox.add(data);
                          int zero = 0;
                          Navigator.pop(context, [
                            widget.currentDuration,
                            zero,
                          ]);
                        } else {
                          print('Error');
                        }
                        /* if (_descriptionActivity.text.isEmpty &&
                            _nameActivity.text.isEmpty) {
                        } else {
                          print('nameactivity = ${_nameActivity.text}');
                          
                        } */
                      },
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  List<String> suggestionName() {
    List<String> suggestion = <String>[];
    List<int> keys = dataBox.keys.cast<int>().toList();
    for (var i = 0; i < keys.length; i++) {
      final ActivityModel item = dataBox.get(i)!;
      suggestion.add(item.name);
    }
    return suggestion.toSet().toList();
  }

  List<String> suggestionDescription() {
    List<String> suggestion = <String>[];
    List<int> keys = dataBox.keys.cast<int>().toList();
    for (var i = 0; i < keys.length; i++) {
      final ActivityModel item = dataBox.get(i)!;
      suggestion.add(item.description);
    }
    return suggestion.toSet().toList();
  }
}
