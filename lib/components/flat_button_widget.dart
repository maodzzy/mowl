import 'package:flutter/material.dart';
import '../theme/appTheme.dart';

class FlatButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const FlatButtonWidget(
      {Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        text,
        style: const TextStyle(
          color: ApplicationTheme.mainColor,
        ),
      ),
      color: ApplicationTheme.secondColor,
      textColor: ApplicationTheme.mainColor,
      onPressed: onPressed,
    );
  }
}
