import 'package:flutter/material.dart';

class PinnedMessageConfiguration {
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadow;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final TextStyle titleTextStyle;
  final TextStyle messageTextStyle;
  final Color iconColor;
  final bool allowRemoveMessage;
  final bool allowPinMessage;

  const PinnedMessageConfiguration({
    this.backgroundColor = Colors.deepPurple,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.allowRemoveMessage = false,
    this.allowPinMessage = false,
    this.boxShadow = const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 4.0,
        offset: Offset(0, 2),
      ),
    ],
    this.padding = const EdgeInsets.all(8.0),
    this.margin = const EdgeInsets.symmetric(vertical: 2.0),
    this.titleTextStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    this.messageTextStyle = const TextStyle(
      color: Colors.white70,
    ),
    this.iconColor = Colors.white,
  });
}
