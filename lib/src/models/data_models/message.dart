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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Message {
  /// Provides id
  final String id;

  /// Used for accessing widget's render box.
  final GlobalKey key;

  /// Provides actual message it will be text or image/audio file path.
  final String message;

  /// Provides message created date time.
  final DateTime createdAt;

  /// Provides id of sender of message.
  final String sentBy;

  /// Provides reply message if user triggers any reply on any message.
  final ReplyMessage replyMessage;

  /// Represents reaction on message.
  final List<Reaction> reactions;

  /// Provides message type.
  final MessageType messageType;

  /// Provides attachment of message.
  final List<Attachment>? attachments;

  /// Status of the message.
  final ValueNotifier<MessageStatus> _status;

  /// Provides list of user who has seen the message.
  final List<String>? seenBy;

  /// Provides max duration for recorded voice message.
  Duration? voiceMessageDuration;

  /// Indicates if message is pinned.
  final bool isPinned;

  /// Provides list of mentions in message.
  final List<dynamic>? mentions;

  Message({
    this.id = '',
    required this.message,
    required this.createdAt,
    required this.sentBy,
    this.replyMessage = const ReplyMessage(),
    List<Reaction>? reactions,
    this.messageType = MessageType.text,
    this.attachments,
    this.voiceMessageDuration,
    this.seenBy,
    MessageStatus status = MessageStatus.pending,
    this.isPinned = false,
    this.mentions,
  })  : key = GlobalKey(),
        reactions = reactions ?? [],
        _status = ValueNotifier(status);

  /// curret messageStatus
  MessageStatus get status => _status.value;

  /// For [MessageStatus] ValueNotfier which is used to for rebuilds
  /// when state changes.
  /// Using ValueNotfier to avoid usage of setState((){}) in order
  /// rerender messages with new receipts.
  ValueNotifier<MessageStatus> get statusNotifier => _status;

  /// This setter can be used to update message receipts, after which the configured
  /// builders will be updated.
  set setStatus(MessageStatus messageStatus) {
    _status.value = messageStatus;
  }

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id']?.toString() ?? '',
        message: json['message']?.toString() ?? '',
        createdAt: (json['created_at'] as Timestamp).toDate().toLocal(),
        sentBy: json['sentBy']?.toString() ?? '',
        replyMessage: json['reply_message'] is Map<String, dynamic>
            ? ReplyMessage.fromJson(json['reply_message'])
            : const ReplyMessage(),
        reactions: json['reactions'] is List<dynamic>
            ? List<Reaction>.from(json['reactions']
                .map((reaction) => Reaction.fromJson(reaction)))
            : [],
        messageType: MessageType.tryParse(json['message_type']?.toString()) ??
            MessageType.text,
        attachments:
            json['attachments'] != null && json['attachments'] is List<dynamic>
                ? List<Attachment>.from(json['attachments']
                    .map((attachment) => Attachment.fromJson(attachment)))
                : json['attachment'] != null &&
                        json['attachment'] is Map<String, dynamic>
                    ? [Attachment.fromJson(json['attachment'])]
                    : null,
        voiceMessageDuration: Duration(
          microseconds:
              int.tryParse(json['voice_message_duration'].toString()) ?? 0,
        ),
        seenBy: json['seen_by'] is List<dynamic>
            ? List<String>.from(json['seen_by'])
            : null,
        status: MessageStatus.tryParse(json['status']?.toString()) ??
            MessageStatus.pending,
        isPinned: json['isPinned'] ?? false,
        mentions: json['mentions'] is List<dynamic>
            ? List<Map<String, String>>.from((json['mentions'] as List).map(
                (item) => Map<String, String>.from((item as Map).map(
                    (key, value) =>
                        MapEntry(key.toString(), value.toString())))))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'created_at': Timestamp.fromDate(createdAt),
        'sentBy': sentBy,
        'reply_message': replyMessage.toJson(),
        'reactions': reactions.map((reaction) => reaction.toJson()).toList(),
        'message_type': messageType.name,
        'attachments':
            attachments?.map((attachment) => attachment.toJson()).toList(),
        'voice_message_duration': voiceMessageDuration?.inMicroseconds,
        'seen_by': seenBy,
        'status': status.name,
        'isPinned': isPinned,
        'mentions': mentions,
      };

  Message copyWith({
    String? id,
    GlobalKey? key,
    String? message,
    DateTime? createdAt,
    String? sentBy,
    ReplyMessage? replyMessage,
    List<Reaction>? reactions,
    MessageType? messageType,
    List<Attachment>? attachments,
    Duration? voiceMessageDuration,
    List<String>? seenBy,
    MessageStatus? status,
    bool? isPinned,
    bool forceNullValue = false,
    List<Map<String, String>>? mentions,
  }) {
    return Message(
      id: id ?? this.id,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      sentBy: sentBy ?? this.sentBy,
      messageType: messageType ?? this.messageType,
      attachments: attachments ?? this.attachments,
      voiceMessageDuration: forceNullValue
          ? voiceMessageDuration
          : voiceMessageDuration ?? this.voiceMessageDuration,
      seenBy: seenBy ?? this.seenBy,
      reactions: reactions ?? this.reactions,
      replyMessage: replyMessage ?? this.replyMessage,
      status: status ?? this.status,
      isPinned: isPinned ?? this.isPinned,
      mentions: mentions ?? this.mentions,
    );
  }
}
