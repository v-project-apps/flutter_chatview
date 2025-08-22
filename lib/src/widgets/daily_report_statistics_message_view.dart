import 'dart:convert';
import 'package:chatview/src/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_models/daily_report_statistics_message.dart';
import '../models/config_models/daily_report_statistics_message_configuration.dart';
import '../models/chat_bubble.dart';
import '../models/data_models/message.dart';

class DailyReportStatisticsMessageView extends StatefulWidget {
  final Message message;
  final bool isMessageBySender;
  final ChatBubble? inComingChatBubbleConfig;
  final ChatBubble? outgoingChatBubbleConfig;
  final double? chatBubbleMaxWidth;
  final DailyReportStatisticsMessageConfiguration?
      dailyReportStatisticsMessageConfiguration;

  const DailyReportStatisticsMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
    this.chatBubbleMaxWidth,
    this.dailyReportStatisticsMessageConfiguration,
  }) : super(key: key);

  @override
  State<DailyReportStatisticsMessageView> createState() =>
      _DailyReportStatisticsMessageViewState();
}

class _DailyReportStatisticsMessageViewState
    extends State<DailyReportStatisticsMessageView> {
  DailyReportStatisticsMessage? _statisticsMessage;
  UserDailyReportStatistics? _currentUserStats;
  late final DateFormat _dateFormatter;

  @override
  void initState() {
    super.initState();
    _dateFormatter = DateFormat('dd.MM.yyyy');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _parseStatisticsMessage();
  }

  void _parseStatisticsMessage() {
    try {
      final currentUserId = chatViewIW?.chatController.currentUser.id;
      final messageData = jsonDecode(widget.message.message);
      _statisticsMessage = DailyReportStatisticsMessage.fromJson(messageData);

      // Get statistics for the current user
      if (currentUserId != null && _statisticsMessage != null) {
        _currentUserStats =
            _statisticsMessage!.getUserStatistics(currentUserId);
      }
    } catch (e) {
      debugPrint('Error parsing daily report statistics message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_statisticsMessage == null || _currentUserStats == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          'No statistics available for your account',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      );
    }

    final config = widget.dailyReportStatisticsMessageConfiguration;
    final isSender = widget.isMessageBySender;

    return Container(
      constraints: BoxConstraints(
        maxWidth: config?.maxWidth ?? widget.chatBubbleMaxWidth ?? 300,
      ),
      padding: config?.padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: config?.backgroundColor ??
            (isSender ? Colors.blue[50] : Colors.grey[50]),
        borderRadius: config?.borderRadius ?? BorderRadius.circular(12),
        border: config?.border ??
            Border.all(
              color: isSender ? Colors.blue[200]! : Colors.grey[300]!,
              width: 1,
            ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(config),
          const SizedBox(height: 16),
          _buildDailyStats(config),
          const SizedBox(height: 16),
          _buildSummaryStats(config),
        ],
      ),
    );
  }

  Widget _buildHeader(DailyReportStatisticsMessageConfiguration? config) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: config?.headerBackgroundColor ?? Colors.blue[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics,
            color: config?.headerIconColor ?? Colors.blue[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statisticsMessage?.customTitle ?? 'Daily Report Statistics',
                  style: config?.headerTitleTextStyle ??
                      const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your Personal Statistics',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyStats(DailyReportStatisticsMessageConfiguration? config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Statistics',
          style: config?.dayStatsTitleTextStyle ??
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 12),
        ...(_currentUserStats?.dailyStats ?? []).map((dayStat) {
          return _buildDayStatItem(dayStat, config);
        }).toList(),
      ],
    );
  }

  Widget _buildDayStatItem(
    DailyReportDayStats dayStat,
    DailyReportStatisticsMessageConfiguration? config,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: config?.dayStatsBackgroundColor ?? Colors.white,
        borderRadius: config?.dayStatsBorderRadius ?? BorderRadius.circular(8),
        border: config?.dayStatsBorder ?? Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Day ${_dateFormatter.format(dayStat.date)}',
            style: config?.dayStatsTitleTextStyle ??
                const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 8),
          _buildStatRow(
            'Twój przychód:',
            '${dayStat.dailyIncome} zł',
            config,
          ),
          const SizedBox(height: 4),
          _buildStatRow(
            'Ilość wysłanych paczek:',
            dayStat.packagesSent,
            config,
          ),
          const SizedBox(height: 4),
          _buildStatRow(
            'Wykonane zadania:',
            '${dayStat.completedTasks}/${dayStat.totalTasks}',
            config,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    String label,
    String value,
    DailyReportStatisticsMessageConfiguration? config,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: config?.dayStatsLabelTextStyle ??
                const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            value,
            style: config?.dayStatsValueTextStyle ??
                const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStats(DailyReportStatisticsMessageConfiguration? config) {
    final summary = _currentUserStats?.summaryStats;
    if (summary == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: config?.summaryBackgroundColor ?? Colors.green[50],
        borderRadius: config?.summaryBorderRadius ?? BorderRadius.circular(8),
        border: config?.summaryBorder ?? Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Summary',
            style: config?.summaryTitleTextStyle ??
                const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Ogólny przychód:',
            '${summary.totalIncome} zł',
            config,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Wysłane paczki:',
            summary.totalPackages,
            config,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Wykonane zadania:',
            '${summary.totalCompletedTasks}/${summary.totalTasks}',
            config,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    DailyReportStatisticsMessageConfiguration? config,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: config?.summaryLabelTextStyle ??
                const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            value,
            style: config?.summaryValueTextStyle ??
                const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
