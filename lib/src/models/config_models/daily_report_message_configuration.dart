import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

class DailyReportMessageConfiguration {
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final EdgeInsets? padding;
  final double? maxWidth;

  // Icon styling
  final Color? iconColor;

  // Title styling
  final TextStyle? titleTextStyle;
  final TextStyle? sectionTitleTextStyle;

  // Field styling
  final Color? fieldBackgroundColor;
  final TextStyle? fieldLabelTextStyle;
  final TextStyle? fieldValueTextStyle;

  // Checkbox styling
  final Color? checkboxColor;
  final Color? checkboxActiveColor;
  final Color? checkboxCheckColor;
  final TextStyle? checkboxTextStyle;

  // Submit button styling
  final Color? submitButtonColor;
  final Color? submitButtonTextColor;
  final TextStyle? submitButtonTextStyle;
  final String? submitButtonText;

  // Behavior options
  final bool showSubmitButton;
  final bool allowMultipleSelection;

  // Callbacks
  final Function({
    required String messageId,
    required UserDailyReportData userDailyReportData,
  })? onReportSubmitted;
  final VoidCallback? onReportCancelled;
  final Widget Function(Message message)? dailyReportMessageBuilder;

  const DailyReportMessageConfiguration({
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.padding,
    this.maxWidth,
    this.iconColor,
    this.titleTextStyle,
    this.sectionTitleTextStyle,
    this.fieldBackgroundColor,
    this.fieldLabelTextStyle,
    this.fieldValueTextStyle,
    this.checkboxColor,
    this.checkboxActiveColor,
    this.checkboxCheckColor,
    this.checkboxTextStyle,
    this.submitButtonColor,
    this.submitButtonTextColor,
    this.submitButtonTextStyle,
    this.submitButtonText,
    this.showSubmitButton = true,
    this.allowMultipleSelection = true,
    this.onReportSubmitted,
    this.onReportCancelled,
    this.dailyReportMessageBuilder,
  });
}
