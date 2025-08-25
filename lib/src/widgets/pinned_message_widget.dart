import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';
import 'dart:convert';
import 'dart:async';

import 'package:intl/intl.dart';

class PinnedMessageWidget extends StatefulWidget {
  final Message message;
  final VoidCallback onTap;
  final PinnedMessageConfiguration pinnedMessageConfiguration;
  final VoidCallback onRemove;

  const PinnedMessageWidget({
    Key? key,
    required this.message,
    required this.onTap,
    required this.pinnedMessageConfiguration,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<PinnedMessageWidget> createState() => _PinnedMessageWidgetState();
}

class _PinnedMessageWidgetState extends State<PinnedMessageWidget> {
  Timer? _timer;
  Timer? _countdownTimer;
  bool _showCountdown = false;
  String _countdownText = '';
  DailyReportMessage? _dailyReportMessage;

  @override
  void initState() {
    super.initState();
    _parseDailyReportMessage();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _parseDailyReportMessage() {
    if (widget.message.messageType.isDailyReport) {
      try {
        final messageData = jsonDecode(widget.message.message);
        _dailyReportMessage = DailyReportMessage.fromJson(messageData);
      } catch (e) {
        debugPrint('Error parsing DailyReportMessage: $e');
      }
    }
  }

  void _startTimer() {
    final maxTime = _dailyReportMessage?.maxCompletionTime;
    if (maxTime == null) return;

    // Timer to switch between title and countdown every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _showCountdown = !_showCountdown;
          if (_showCountdown) {
            _updateCountdown();
            _startCountdownTimer();
          } else {
            _countdownTimer?.cancel();
          }
        });
      }
    });

    // Update countdown immediately if we're in countdown mode
    if (_showCountdown) {
      _updateCountdown();
      _startCountdownTimer();
    }
  }

  void _startCountdownTimer() {
    // Update countdown every second when in countdown mode
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _showCountdown) {
        setState(() {
          _updateCountdown();
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _updateCountdown() {
    final maxTime = _dailyReportMessage?.maxCompletionTime;
    if (maxTime == null) return;

    final now = DateTime.now();

    if (now.isAfter(maxTime)) {
      _countdownText = 'Czas minął';
    } else {
      final difference = maxTime.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);

      if (hours > 0) {
        _countdownText = 'Pozostało ${hours}h ${minutes}m';
      } else {
        _countdownText = 'Pozostało ${minutes}m';
      }
    }
  }

  String get messageText {
    switch (widget.message.messageType) {
      case MessageType.text:
        return widget.message.message;
      case MessageType.imageFromUrl:
      case MessageType.image:
        return 'Image';
      case MessageType.voice:
        return 'Voice message';
      case MessageType.videoFromUrl:
      case MessageType.video:
        return 'Video';
      case MessageType.file:
        return 'File';
      case MessageType.dailyReport:
        if (_dailyReportMessage != null) {
          final title = _dailyReportMessage!.customTitle ?? 'Daily Report';
          if (_showCountdown &&
              _dailyReportMessage!.maxCompletionTime != null) {
            return '$title | $_countdownText - przejdź do zadań';
          } else if (_dailyReportMessage!.maxCompletionTime != null) {
            return '$title | Czas do ${DateFormat('HH:mm').format(_dailyReportMessage!.maxCompletionTime!)} - przejdź do zadań';
          } else {
            return '$title - przejdź do zadań';
          }
        }
        return 'Daily Report - przejdź do zadań';
      case MessageType.voting:
        return 'Poll - przejdź do głosowania';
      case MessageType.quiz:
        return 'Quiz - przejdź do odpowiedzi';
      case MessageType.question:
        return 'Question - przejdź do odpowiedzi';
      case MessageType.dailyReportStatistics:
        return 'Statistics - przejdź do statystyk';
      case MessageType.imageWithText:
        return 'Image - ${widget.message.message}';
      case MessageType.imageCarousel:
        return 'Image Carousel';
      default:
        return 'Message';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: widget.pinnedMessageConfiguration.backgroundColor,
          borderRadius: widget.pinnedMessageConfiguration.borderRadius,
          boxShadow: widget.pinnedMessageConfiguration.boxShadow,
        ),
        padding: widget.pinnedMessageConfiguration.padding,
        margin: widget.pinnedMessageConfiguration.margin,
        child: Row(
          children: [
            Icon(Icons.push_pin_outlined,
                color: widget.pinnedMessageConfiguration.iconColor),
            const SizedBox(width: 8.0),
            if (widget.message.messageType.isImage) ...[
              CachedNetworkImage(
                imageUrl: widget.message.attachments?.first.url ??
                    widget.message.message,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(width: 8.0)
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pinned Message",
                    style: widget.pinnedMessageConfiguration.titleTextStyle,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    messageText,
                    style: widget.pinnedMessageConfiguration.messageTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (widget.pinnedMessageConfiguration.allowRemoveMessage)
              IconButton(
                icon: Icon(Icons.close,
                    color: widget.pinnedMessageConfiguration.iconColor),
                onPressed: widget.onRemove,
              ),
          ],
        ),
      ),
    );
  }
}
