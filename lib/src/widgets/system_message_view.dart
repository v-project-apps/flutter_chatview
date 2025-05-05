import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';
import 'package:chatview/src/values/mention_configuration.dart';
import 'mention_text.dart';

class SystemMessageView extends StatelessWidget {
  const SystemMessageView({
    Key? key,
    required this.message,
    this.mentionColor,
  }) : super(key: key);

  final Message message;
  final Color? mentionColor;

  @override
  Widget build(BuildContext context) {
    // Convert mentions to the required format
    Map<String, String>? mentionsMap;
    if (message.mentions != null) {
      mentionsMap = {};
      for (var mentionMap in message.mentions!) {
        mentionMap.forEach((key, value) {
          mentionsMap![key] = value;
        });
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: MentionText(
            text: message.message,
            mentions: mentionsMap,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[700],
                ),
            textAlign: TextAlign.center,
            mentionConfiguration: MentionConfiguration(
                textColor: mentionColor ?? Colors.blue,
                fontWeight: FontWeight.bold,
                showMentionStartSymbol: false),
          ),
        ),
      ),
    );
  }
}
