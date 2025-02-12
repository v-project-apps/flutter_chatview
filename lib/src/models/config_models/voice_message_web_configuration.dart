import 'package:flutter/material.dart';

class VoiceMessageWebConfiguration {
  /// Icon for playing the audio on web.
  final Icon? playIcon;

  /// Icon for pausing audio on web.
  final Icon? pauseIcon;

  /// BoxDecoration for the web voice message bubble.
  final BoxDecoration? decoration;

  /// Active color for the progress slider.
  final Color? sliderActiveColor;

  /// Inactive color for the progress slider.
  final Color? sliderInactiveColor;

  /// Padding for the web voice message view.
  final EdgeInsets? padding;

  /// Margin for the web voice message view.
  final EdgeInsets? margin;

  const VoiceMessageWebConfiguration({
    this.playIcon,
    this.pauseIcon,
    this.decoration,
    this.sliderActiveColor,
    this.sliderInactiveColor,
    this.padding,
    this.margin,
  });
}
