import 'package:flutter/material.dart';

class PoolsPickerBottomSheetConfiguration {
  const PoolsPickerBottomSheetConfiguration({
    this.bottomSheetPadding,
    this.backgroundColor,
    this.attachmentWidgetPadding,
    this.attachmentWidgetMargin,
    this.attachmentWidgetDecoration,
    this.enablePollCreation = true,
    this.enableQuizCreation = true,
    this.enableQuestionCreation = true,
    this.enableDailyReportCreation = true,
    this.enableDailyReportStatisticsCreation = true,
  });

  /// Used for giving padding of bottom sheet.
  final EdgeInsetsGeometry? bottomSheetPadding;

  /// Used for giving padding of reaction widget in bottom sheet.
  final EdgeInsetsGeometry? attachmentWidgetPadding;

  /// Used for giving margin of bottom sheet.
  final EdgeInsetsGeometry? attachmentWidgetMargin;

  final BoxDecoration? attachmentWidgetDecoration;

  /// Enable/disable send poll. Enabled by default.
  final bool enablePollCreation;

  /// Enable/disable send quiz. Enabled by default.
  final bool enableQuizCreation;

  /// Enable/disable send question. Enabled by default.
  final bool enableQuestionCreation;

  /// Enable/disable send daily report. Enabled by default.
  final bool enableDailyReportCreation;

  /// Enable/disable send daily report statistics. Enabled by default.
  final bool enableDailyReportStatisticsCreation;

  /// Used for giving background color of bottom sheet.
  final Color? backgroundColor;
}
