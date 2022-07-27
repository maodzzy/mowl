import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final Color color;
  final Icon icon;
  final double iconSize;
  final VoidCallback onClicked;

  const IconButtonWidget(
      {Key? key,
      required this.onClicked,
      required this.color,
      required this.iconSize,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
      icon: icon,
      iconSize: iconSize,
      color: color,
      tooltip: 'Press button',
      onPressed: onClicked);
}
