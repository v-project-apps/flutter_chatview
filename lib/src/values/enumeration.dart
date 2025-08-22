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

// Different types Message of ChatView

import 'package:chatview/src/values/attachment_source.dart';
import 'package:flutter/material.dart';

enum MessageType {
  text,
  image,
  imageFromUrl,
  gif,
  video,
  videoFromUrl,
  audio,
  file,
  custom,
  voice,
  system,
  voting,
  quiz,
  question,
  dailyReport,
  dailyReportStatistics;

  String get textName {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.imageFromUrl:
        return 'imageFromUrl';
      case MessageType.gif:
        return 'gif';
      case MessageType.video:
        return 'video';
      case MessageType.videoFromUrl:
        return 'videoFromUrl';
      case MessageType.audio:
        return 'audio';
      case MessageType.file:
        return 'file';
      case MessageType.custom:
        return 'custom';
      case MessageType.voice:
        return 'voice';
      case MessageType.system:
        return 'system';
      case MessageType.voting:
        return 'voting';
      case MessageType.quiz:
        return 'quiz';
      case MessageType.question:
        return 'question';
      case MessageType.dailyReport:
        return 'dailyReport';
      case MessageType.dailyReportStatistics:
        return 'dailyReportStatistics';
    }
  }

  bool get isVoting => this == voting;
  bool get isQuiz => this == quiz;
  bool get isQuestion => this == question;
  bool get isDailyReport => this == dailyReport;
  bool get isDailyReportStatistics => this == dailyReportStatistics;

  static MessageType? tryParse(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'text':
        return MessageType.text;
      case 'image':
        return MessageType.image;
      case 'imageFromUrl':
        return MessageType.imageFromUrl;
      case 'gif':
        return MessageType.gif;
      case 'video':
        return MessageType.video;
      case 'videoFromUrl':
        return MessageType.videoFromUrl;
      case 'audio':
        return MessageType.audio;
      case 'file':
        return MessageType.file;
      case 'custom':
        return MessageType.custom;
      case 'voice':
        return MessageType.voice;
      case 'system':
        return MessageType.system;
      case 'voting':
        return MessageType.voting;
      case 'quiz':
        return MessageType.quiz;
      case 'question':
        return MessageType.question;
      case 'dailyReport':
        return MessageType.dailyReport;
      case 'dailyReportStatistics':
        return MessageType.dailyReportStatistics;
      default:
        return null;
    }
  }

  static MessageType fromAttachmentSource(AttachmentSource source) {
    switch (source) {
      case AttachmentSource.camera:
      case AttachmentSource.gallery:
        return MessageType.image;
      case AttachmentSource.imageFromUrl:
        return MessageType.imageFromUrl;
      case AttachmentSource.gif:
        return MessageType.gif;
      case AttachmentSource.video:
        return MessageType.video;
      case AttachmentSource.videoFromUrl:
        return MessageType.videoFromUrl;
      case AttachmentSource.file:
        return MessageType.file;
      case AttachmentSource.audioFromFile:
      case AttachmentSource.audioFromUrl:
        return MessageType.voice;
      case AttachmentSource.poll:
        return MessageType.voting;
      case AttachmentSource.quiz:
        return MessageType.quiz;
      case AttachmentSource.question:
        return MessageType.question;
      case AttachmentSource.dailyReport:
        return MessageType.dailyReport;
      case AttachmentSource.dailyReportStatistics:
        return MessageType.dailyReportStatistics;
    }
  }
}

/// Events, Wheter the user is still typing a message or has
/// typed the message
enum TypeWriterStatus { typing, typed }

/// [MessageStatus] defines the current state of the message
/// if you are sender sending a message then, the
enum MessageStatus {
  read,
  delivered,
  undelivered,
  pending;

  static MessageStatus? tryParse(String? value) {
    final status = value?.trim().toLowerCase();
    if (status?.isEmpty ?? true) return null;
    if (status == read.name) {
      return read;
    } else if (status == delivered.name) {
      return delivered;
    } else if (status == undelivered.name) {
      return undelivered;
    } else if (status == pending.name) {
      return pending;
    }
    return null;
  }
}

/// Types of states
enum ChatViewState { hasMessages, noData, loading, error }

enum ShowReceiptsIn { all, lastMessage }

enum ImageType {
  asset,
  network,
  base64;

  bool get isNetwork => this == ImageType.network;

  bool get isAsset => this == ImageType.asset;

  bool get isBase64 => this == ImageType.base64;

  static ImageType? tryParse(String? value) {
    final type = value?.trim().toLowerCase();
    if (type?.isEmpty ?? true) return null;
    if (type == asset.name) {
      return asset;
    } else if (type == network.name) {
      return network;
    } else if (type == base64.name) {
      return base64;
    }
    return null;
  }
}

enum SuggestionListAlignment {
  left(Alignment.bottomLeft),
  center(Alignment.bottomCenter),
  right(Alignment.bottomRight);

  const SuggestionListAlignment(this.alignment);

  final Alignment alignment;
}

extension ChatViewStateExtension on ChatViewState {
  bool get hasMessages => this == ChatViewState.hasMessages;

  bool get isLoading => this == ChatViewState.loading;

  bool get isError => this == ChatViewState.error;

  bool get noMessages => this == ChatViewState.noData;
}

enum GroupedListOrder { asc, desc }

extension GroupedListOrderExtension on GroupedListOrder {
  bool get isAsc => this == GroupedListOrder.asc;

  bool get isDesc => this == GroupedListOrder.desc;
}

enum ScrollButtonAlignment {
  left(Alignment.bottomLeft),
  center(Alignment.bottomCenter),
  right(Alignment.bottomRight);

  const ScrollButtonAlignment(this.alignment);

  final Alignment alignment;
}

enum SuggestionItemsType {
  scrollable,
  multiline;

  bool get isScrollType => this == SuggestionItemsType.scrollable;

  bool get isMultilineType => this == SuggestionItemsType.multiline;
}
