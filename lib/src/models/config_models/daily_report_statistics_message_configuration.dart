import 'package:flutter/material.dart';

/// Configuration for the DailyReportStatisticsMessageView
class DailyReportStatisticsMessageConfiguration {
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final EdgeInsets? padding;
  final double? maxWidth;

  // Header styling
  final Color? headerBackgroundColor;
  final TextStyle? headerTitleTextStyle;
  final TextStyle? headerSubtitleTextStyle;
  final Color? headerIconColor;

  // Day stats styling
  final Color? dayStatsBackgroundColor;
  final BorderRadius? dayStatsBorderRadius;
  final Border? dayStatsBorder;
  final TextStyle? dayStatsTitleTextStyle;
  final TextStyle? dayStatsValueTextStyle;
  final TextStyle? dayStatsLabelTextStyle;
  final Color? dayStatsDividerColor;

  // Summary stats styling
  final Color? summaryBackgroundColor;
  final BorderRadius? summaryBorderRadius;
  final Border? summaryBorder;
  final TextStyle? summaryTitleTextStyle;
  final TextStyle? summaryValueTextStyle;
  final TextStyle? summaryLabelTextStyle;

  // Date formatting
  final String? dateFormat;
  final TextStyle? dateTextStyle;
  final Color? dateTextColor;

  // Task completion styling
  final Color? taskCompletionColor;
  final Color? taskIncompleteColor;
  final TextStyle? taskCompletionTextStyle;

  // Callbacks
  final VoidCallback? onStatsTapped;
  final Widget Function(
          String userId, List<dynamic> dailyStats, dynamic summaryStats)?
      statisticsMessageBuilder;

  const DailyReportStatisticsMessageConfiguration({
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.padding,
    this.maxWidth,
    this.headerBackgroundColor,
    this.headerTitleTextStyle,
    this.headerSubtitleTextStyle,
    this.headerIconColor,
    this.dayStatsBackgroundColor,
    this.dayStatsBorderRadius,
    this.dayStatsBorder,
    this.dayStatsTitleTextStyle,
    this.dayStatsValueTextStyle,
    this.dayStatsLabelTextStyle,
    this.dayStatsDividerColor,
    this.summaryBackgroundColor,
    this.summaryBorderRadius,
    this.summaryBorder,
    this.summaryTitleTextStyle,
    this.summaryValueTextStyle,
    this.summaryLabelTextStyle,
    this.dateFormat,
    this.dateTextStyle,
    this.dateTextColor,
    this.taskCompletionColor,
    this.taskIncompleteColor,
    this.taskCompletionTextStyle,
    this.onStatsTapped,
    this.statisticsMessageBuilder,
  });
}
