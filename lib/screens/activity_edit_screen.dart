import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../data/activity_model.dart';
import '../theme/appTheme.dart';
import '../components/components.dart';
import '../components/date_time_picker_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityEditScreen extends StatefulWidget {
  ActivityModel newitem;
  DateTime currentDate = DateTime.now();

  ActivityEditScreen({Key? key, ActivityModel? newitem, DateTime? currentDate})
      : newitem = newitem ??
            ActivityModel(
              name: '',
              description: '',
              start: currentDate ?? DateTime.now(),
              end: currentDate ?? DateTime.now(),
            ),
        super(key: key);

  @override
  State<ActivityEditScreen> createState() => _ActivityEditScreenState();
}

class _ActivityEditScreenState extends State<ActivityEditScreen> {
  final _namedController = TextEditingController();
  final _descriptionController = TextEditingController();
  var endText = '';
  var startText = '';
  final dateFormatter = DateFormat('MMMM dd hh:mm');
  final _formKey = GlobalKey<FormState>();
  Box<ActivityModel> dataBox = ActivityModel.dataBox;

  @override
  Widget build(BuildContext context) {
    _namedController.text = widget.newitem.name;
    _namedController.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.newitem.name.length));
    _descriptionController.text = widget.newitem.description;
    _descriptionController.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.newitem.description.length));
    startText =
        AppLocalizations.of(context).dateTime(widget.newitem.start).toString();
    endText =
        AppLocalizations.of(context).dateTime(widget.newitem.end).toString();
    return Scaffold(
      backgroundColor: ApplicationTheme.mainColor,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ActivityTile(key: widget.key, item: widget.newitem),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 80, right: 80, top: 20),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context).enterText;
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _namedController,
                  keyboardType: TextInputType.text,
                  cursorColor: ApplicationTheme.secondColor,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationTheme.secondColor, width: 2.0)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationTheme.lightColor, width: 2.0)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationTheme.secondColor, width: 2.0)),
                    disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationTheme.secondColor, width: 2.0)),
                    labelText: AppLocalizations.of(context).name,
                    labelStyle:
                        const TextStyle(color: ApplicationTheme.secondColor),
                    filled: true,
                    fillColor: ApplicationTheme.mainColor,
                    focusColor: Colors.orange.shade100,
                  ),
                  onChanged: (value) {
                    setState(() {
                      widget.newitem.name = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 80, right: 80, top: 20),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context).enterText;
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationTheme.secondColor, width: 2.0)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationTheme.lightColor, width: 2.0)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationTheme.secondColor, width: 2.0)),
                    disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ApplicationTheme.secondColor, width: 2.0)),
                    labelText: AppLocalizations.of(context).description,
                    labelStyle:
                        const TextStyle(color: ApplicationTheme.secondColor),
                    filled: true,
                    fillColor: ApplicationTheme.mainColor,
                    focusColor: Colors.orange.shade100,
                  ),
                  onChanged: (value) {
                    setState(() {
                      widget.newitem.description = value;
                    });
                  },
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final _currentDate = await Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false, // set to false
                      pageBuilder: (_, __, ___) => DateTimePickerWidget(
                        firstDateTime: widget.newitem.start,
                        secondDateTime: widget.newitem.start,
                        start: true,
                      ),
                    ),
                  );
                  print('current = $_currentDate');
                  setState(() {
                    if (_currentDate != null) {
                      widget.newitem.start = _currentDate;
                    }

                    widget.newitem.name = _namedController.text;
                    widget.newitem.description = _descriptionController.text;
                    print('end=${widget.newitem.start.toString()}');
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 80, right: 80, top: 20),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(12),
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: ApplicationTheme.secondColor),
                      color: ApplicationTheme.mainColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      startText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final currentDate = await Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false, // set to false
                      pageBuilder: (_, __, ___) => DateTimePickerWidget(
                        firstDateTime: widget.newitem.end,
                        secondDateTime: widget.newitem.end,
                        start: false,
                      ),
                    ),
                  );
                  setState(() {
                    if (currentDate != null) {
                      widget.newitem.end = currentDate;
                    }

                    widget.newitem.name = _namedController.text;
                    widget.newitem.description = _descriptionController.text;
                    print('end=${widget.newitem.end.toString()}');
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 80, right: 80, top: 20),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(12),
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: ApplicationTheme.secondColor),
                      color: ApplicationTheme.mainColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      endText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FlatButtonWidget(
                  text: 'OK',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.newitem.start = widget.newitem.start;
                      widget.newitem.name = _namedController.text;
                      widget.newitem.description = _descriptionController.text;
                      widget.newitem.end = widget.newitem.end;

                      Navigator.pop(context, [true, widget.newitem]);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
