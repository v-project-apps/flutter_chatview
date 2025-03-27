import 'package:flutter/material.dart';

/// Configuration for mention styling in chat messages
class MentionConfiguration {
  const MentionConfiguration({
    this.textColor = Colors.blue,
    this.backgroundColor = const Color(0xFFE3F2FD),
    this.fontWeight = FontWeight.bold,
    this.height = 1.5,
    this.letterSpacing = 0.2,
    this.fontSize,
    this.mentionStart = const ['@'],
    this.mentionBreak = ' ',
    this.allowDecrement = true,
    this.allowEmbedding = true,
    this.showMentionStartSymbol = false,
    this.maxWords,
  });

  /// Color of the mention text
  final Color textColor;

  /// Background color of the mention
  final Color backgroundColor;

  /// Font weight of the mention text
  final FontWeight fontWeight;

  /// Height multiplier for the mention text
  final double height;

  /// Letter spacing for the mention text
  final double letterSpacing;

  /// Font size for the mention text (optional)
  final double? fontSize;

  /// Characters that trigger mention suggestions
  final List<String> mentionStart;

  /// Character that breaks the mention
  final String mentionBreak;

  /// Whether to allow decrementing mentions
  final bool allowDecrement;

  /// Whether to allow embedding mentions
  final bool allowEmbedding;

  /// Whether to show the mention start symbol
  final bool showMentionStartSymbol;

  /// Maximum number of words in a mention
  final int? maxWords;
}
