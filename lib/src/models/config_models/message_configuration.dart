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
import 'package:flutter/material.dart';

import '../../values/typedefs.dart';
import '../models.dart';

class MessageConfiguration {
  /// Provides configuration of image message appearance.
  final ImageMessageConfiguration? imageMessageConfig;

  /// Provides configuration of image message appearance.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Provides configuration of emoji messages appearance.
  final EmojiMessageConfiguration? emojiMessageConfig;

  /// Provides builder to create view for custom messages.
  final Widget Function(Message)? customMessageBuilder;

  /// Provides configuration for voting messages.
  final VotingMessageConfiguration? votingMessageConfig;

  /// Provides configuration for quiz messages.
  final QuizMessageConfiguration? quizMessageConfig;

  /// Provides configuration for question messages.
  final QuestionMessageConfiguration? questionMessageConfig;

  /// Provides configuration for daily report messages.
  final DailyReportMessageConfiguration? dailyReportMessageConfig;
  final DailyReportStatisticsMessageConfiguration?
      dailyReportStatisticsMessageConfig;

  /// Configurations for voice message bubble
  final VoiceMessageConfiguration? voiceMessageConfig;

  /// Configurations for video message bubble
  final VideoMessageConfiguration? videoMessageConfig;

  /// Configurations for file message bubble
  final FileMessageConfiguration? fileMessageConfig;

  /// Configurations for image with text message bubble
  final ImageWithTextMessageConfiguration? imageWithTextMessageConfig;

  /// Configurations for image carousel message bubble
  final ImageCarouselMessageConfiguration? imageCarouselMessageConfig;

  /// To customize reply view for custom message type
  final CustomMessageReplyViewBuilder? customMessageReplyViewBuilder;

  /// Current user ID for filtering user-specific data in statistics messages
  final String? currentUserId;

  const MessageConfiguration({
    this.imageMessageConfig,
    this.messageReactionConfig,
    this.emojiMessageConfig,
    this.customMessageBuilder,
    this.votingMessageConfig,
    this.quizMessageConfig,
    this.questionMessageConfig,
    this.dailyReportMessageConfig,
    this.dailyReportStatisticsMessageConfig,
    this.voiceMessageConfig,
    this.customMessageReplyViewBuilder,
    this.videoMessageConfig,
    this.fileMessageConfig,
    this.imageWithTextMessageConfig,
    this.imageCarouselMessageConfig,
    this.currentUserId,
  });
}
