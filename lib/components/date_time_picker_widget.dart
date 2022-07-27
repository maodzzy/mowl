import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/flat_button_widget.dart';

class DateTimePickerWidget extends StatelessWidget {
  final DateTime firstDateTime;
  final DateTime secondDateTime;
  final bool start;
  // if compare = true than we get start time else we get end time

  const DateTimePickerWidget(
      {Key? key,
      required this.firstDateTime,
      required this.secondDateTime,
      required this.start})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime _currentDateTime;
    if (start) {
      _currentDateTime = firstDateTime;
    } else {
      _currentDateTime = secondDateTime;
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.black45,
        child: Center(
          child: Card(
            elevation: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        onDateTimeChanged: (data) {
                          if (start) {
                            if (data.isBefore(secondDateTime)) {
                              _currentDateTime = data;
                            }
                          } else {
                            if (data.isAfter(secondDateTime)) {
                              _currentDateTime = data;
                            }
                          }
                        },
                        initialDateTime: _currentDateTime,
                      ),
                    ),
                    FlatButtonWidget(
                        text: 'OK',
                        onPressed: () {
                          Navigator.pop(context, _currentDateTime);
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
