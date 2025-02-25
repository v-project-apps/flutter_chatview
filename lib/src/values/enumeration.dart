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
  image,
  imageFromUrl,
  video,
  videoFromUrl,
  file,
  text,
  voice,
  custom;

  String get textName {
    switch (this) {
      case image:
      case imageFromUrl:
        return 'image';
      case video:
      case videoFromUrl:
        return 'video';
      case file:
        return 'file';
      case text:
        return 'text';
      case voice:
        return 'voice';
      case custom:
        return 'message';
    }
  }

  static MessageType? tryParse(String? value) {
    final type = value?.trim();
    if (type?.isEmpty ?? true) return null;
    if (type == image.name) {
      return image;
    } else if (type == imageFromUrl.name) {
      return imageFromUrl;
    } else if (type == text.name) {
      return text;
    } else if (type == voice.name) {
      return voice;
    } else if (type == video.name) {
      return video;
    } else if (type == videoFromUrl.name) {
      return videoFromUrl;
    } else if (type == file.name) {
      return file;
    } else if (type == custom.name) {
      return custom;
    }
    return null;
  }

  static MessageType fromAttachmentSource(AttachmentSource source) {
    switch (source) {
      case AttachmentSource.camera:
        return MessageType.image;
      case AttachmentSource.gallery:
        return MessageType.image;
      case AttachmentSource.imageFromUrl:
        return MessageType.imageFromUrl;
      case AttachmentSource.file:
        return MessageType.file;
      case AttachmentSource.video:
        return MessageType.video;
      case AttachmentSource.videoFromUrl:
        return MessageType.videoFromUrl;
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
