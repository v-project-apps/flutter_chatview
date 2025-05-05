import 'package:flutter/material.dart';
import 'package:chatview/src/values/mention_configuration.dart';

/// A widget that displays text with mentions highlighted.
class MentionText extends StatelessWidget {
  const MentionText({
    Key? key,
    required this.text,
    required this.mentions,
    this.style,
    this.mentionConfiguration,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  }) : super(key: key);

  /// The text to display with mentions
  final String text;

  /// Map of mentions where key is the user ID and value is the username
  final Map<String, String>? mentions;

  /// Base text style for non-mention text
  final TextStyle? style;

  /// Configuration for mention styling
  final MentionConfiguration? mentionConfiguration;

  /// How the text should be aligned horizontally
  final TextAlign textAlign;

  /// The maximum number of lines for the text to span
  final int? maxLines;

  /// How visual overflow should be handled
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    if (mentions == null || mentions!.isEmpty) {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final List<TextSpan> textSpans = [];
    String remainingText = text;

    while (remainingText.isNotEmpty) {
      final mentionIndex = remainingText.indexOf('@');
      if (mentionIndex == -1) {
        // No more mentions, add remaining text
        textSpans.add(TextSpan(
          text: remainingText,
          style: style,
        ));
        break;
      }

      // Add text before mention
      if (mentionIndex > 0) {
        textSpans.add(TextSpan(
          text: remainingText.substring(0, mentionIndex),
          style: style,
        ));
      }

      // Find a matching mention from the mentions list
      String? matchedMention;
      int matchEndIndex = mentionIndex;

      // Sort mentions by length (longest first) to match the most specific mention
      final sortedMentions = mentions!.entries.toList()
        ..sort((a, b) => b.value.length.compareTo(a.value.length));

      for (final mention in sortedMentions) {
        final mentionValue = mention.value;
        final mentionWithAt = '@$mentionValue';

        // Check if the remaining text starts with this mention (case insensitive)
        if (remainingText
            .substring(mentionIndex)
            .toLowerCase()
            .startsWith(mentionWithAt.toLowerCase())) {
          matchedMention = mentionWithAt;
          matchEndIndex = mentionIndex + mentionWithAt.length;
          break;
        }
      }

      if (matchedMention != null) {
        // Add the matched mention with highlighting
        final mentionText =
            mentionConfiguration?.showMentionStartSymbol == false
                ? remainingText.substring(
                    mentionIndex + 1, matchEndIndex) // Skip the @ symbol
                : remainingText.substring(mentionIndex, matchEndIndex);

        textSpans.add(TextSpan(
          text: mentionText,
          style: style?.copyWith(
            color: mentionConfiguration?.textColor ?? Colors.blue,
            fontWeight: mentionConfiguration?.fontWeight ?? FontWeight.bold,
            fontSize: mentionConfiguration?.fontSize,
            height: mentionConfiguration?.height,
            letterSpacing: mentionConfiguration?.letterSpacing,
          ),
        ));
        remainingText = remainingText.substring(matchEndIndex);
      } else {
        // No match found, treat @ as normal text
        textSpans.add(TextSpan(
          text: '@',
          style: style,
        ));
        remainingText = remainingText.substring(mentionIndex + 1);
      }
    }

    return RichText(
      text: TextSpan(children: textSpans),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
