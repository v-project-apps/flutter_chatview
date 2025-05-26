/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'package:chatview/chatview.dart';

class ReplyMessage {
  /// Provides reply message.
  final String message;

  /// Provides user id of who replied message.
  final String replyBy;

  /// Provides user id of whom to reply.
  final String replyTo;

  /// Provides message type.
  final MessageType messageType;

  /// Provides attachment of message.
  final Attachment? attachment;

  /// Provides list of mentions in message.
  final List<dynamic>? mentions;

  /// Provides max duration for recorded voice message.
  final Duration? voiceMessageDuration;

  /// Id of message, it replies to.
  final String messageId;

  const ReplyMessage({
    this.messageId = '',
    this.message = '',
    this.replyTo = '',
    this.replyBy = '',
    this.messageType = MessageType.text,
    this.voiceMessageDuration,
    this.attachment,
    this.mentions,
  });

  factory ReplyMessage.fromJson(Map<String, dynamic> json) => ReplyMessage(
        message: json['message']?.toString() ?? '',
        replyBy: json['reply_by']?.toString() ?? '',
        replyTo: json['reply_bo']?.toString() ?? '',
        messageType: MessageType.tryParse(json['message_type']?.toString()) ??
            MessageType.text,
        messageId: json['id']?.toString() ?? '',
        voiceMessageDuration: Duration(
          microseconds:
              int.tryParse(json['voice_message_duration'].toString()) ?? 0,
        ),
        attachment: json['attachment'] != null &&
                json['attachment'] is Map<String, dynamic>
            ? Attachment.fromJson(json['attachment'])
            : null,
        mentions: json['mentions'] is List<dynamic>
            ? List<Map<String, String>>.from((json['mentions'] as List).map(
                (item) => Map<String, String>.from((item as Map).map(
                    (key, value) =>
                        MapEntry(key.toString(), value.toString())))))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'reply_by': replyBy,
        'reply_to': replyTo,
        'message_type': messageType.name,
        'id': messageId,
        'voice_message_duration': voiceMessageDuration?.inMicroseconds,
        'attachment': attachment?.toJson(),
        'mentions': mentions,
      };

  ReplyMessage copyWith({
    String? messageId,
    String? message,
    String? replyTo,
    String? replyBy,
    MessageType? messageType,
    Duration? voiceMessageDuration,
    bool forceNullValue = false,
    Attachment? attachment,
    List<dynamic>? mentions,
  }) {
    return ReplyMessage(
      messageId: messageId ?? this.messageId,
      message: message ?? this.message,
      replyTo: replyTo ?? this.replyTo,
      replyBy: replyBy ?? this.replyBy,
      messageType: messageType ?? this.messageType,
      voiceMessageDuration: forceNullValue
          ? voiceMessageDuration
          : voiceMessageDuration ?? this.voiceMessageDuration,
      attachment: attachment ?? this.attachment,
      mentions: mentions ?? this.mentions,
    );
  }
}
