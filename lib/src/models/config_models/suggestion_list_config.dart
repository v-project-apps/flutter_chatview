import '../../values/enumeration.dart';
import 'package:flutter/cupertino.dart';

class SuggestionListConfig {
  final BoxDecoration? decoration;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double itemSeparatorWidth;
  final SuggestionListAlignment axisAlignment;
  final Axis? listDirection;

  const SuggestionListConfig({
    this.decoration,
    this.padding,
    this.margin,
    this.axisAlignment = SuggestionListAlignment.right,
    this.itemSeparatorWidth = 8,
    this.listDirection,
  });
}
