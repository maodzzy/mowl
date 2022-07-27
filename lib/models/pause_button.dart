import 'package:flutter/material.dart';
import '../theme/appTheme.dart';
import '../components/components.dart';

class PauseButton extends StatelessWidget {
  final VoidCallback onClicked;

  const PauseButton({Key? key, required this.onClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: IconButtonWidget(
            color: ApplicationTheme.secondColor,
            icon: const Icon(Icons.pause_circle_filled),
            iconSize: 90,
            onClicked: onClicked));
  }
}
