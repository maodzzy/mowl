import 'package:flutter/material.dart';
import '../theme/appTheme.dart';
import '../components/components.dart';

class PlayButton extends StatelessWidget {
  final VoidCallback onClicked;

  const PlayButton({Key? key, required this.onClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: IconButtonWidget(
            color: ApplicationTheme.secondColor,
            icon: const Icon(Icons.play_circle_fill),
            iconSize: 100,
            onClicked: onClicked));
  }
}
