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
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

import '../utils/constants/constants.dart';
import '../utils/package_strings.dart';
import 'chat_view_inherited_widget.dart';
import 'vertical_line.dart';

class ReplyMessageWidget extends StatelessWidget {
  const ReplyMessageWidget({
    Key? key,
    required this.message,
    this.repliedMessageConfig,
    this.onTap,
  }) : super(key: key);

  /// Provides message instance of chat.
  final Message message;

  /// Provides configurations related to replied message such as textstyle
  /// padding, margin etc. Also, this widget is located upon chat bubble.
  final RepliedMessageConfiguration? repliedMessageConfig;

  /// Provides call back when user taps on replied message.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chatController = ChatViewInheritedWidget.of(context)?.chatController;
    final currentUser = chatController?.currentUser;
    final replyBySender = message.replyMessage.replyBy == currentUser?.id;
    final textTheme = Theme.of(context).textTheme;
    final messagedUser =
        chatController?.getUserFromId(message.replyMessage.replyBy);
    final replyBy = replyBySender ? PackageStrings.you : messagedUser?.name;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: repliedMessageConfig?.margin ??
            const EdgeInsets.only(
              right: horizontalPadding,
              left: horizontalPadding,
              bottom: 4,
            ),
        constraints:
            BoxConstraints(maxWidth: repliedMessageConfig?.maxWidth ?? 360),
        child: Column(
          crossAxisAlignment:
              replyBySender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              "${PackageStrings.repliedBy} $replyBy",
              style: repliedMessageConfig?.replyTitleTextStyle ??
                  textTheme.bodyMedium!
                      .copyWith(fontSize: 14, letterSpacing: 0.3),
            ),
            const SizedBox(height: 6),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: replyBySender
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!replyBySender)
                    VerticalLine(
                      verticalBarWidth: repliedMessageConfig?.verticalBarWidth,
                      verticalBarColor: repliedMessageConfig?.verticalBarColor,
                      rightPadding: 4,
                    ),
                  Flexible(
                    child: Opacity(
                      opacity: repliedMessageConfig?.opacity ?? 0.8,
                      child: _buildReplyContent(
                        context,
                        message.replyMessage,
                        replyBySender,
                        textTheme,
                      ),
                    ),
                  ),
                  if (replyBySender)
                    VerticalLine(
                      verticalBarWidth: repliedMessageConfig?.verticalBarWidth,
                      verticalBarColor: repliedMessageConfig?.verticalBarColor,
                      leftPadding: 4,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyContent(
    BuildContext context,
    ReplyMessage replyMessage,
    bool replyBySender,
    TextTheme textTheme,
  ) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: repliedMessageConfig?.maxWidth ?? 360),
      padding: repliedMessageConfig?.padding ??
          const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
      decoration: BoxDecoration(
        borderRadius: _borderRadius(
          replyMessage: replyMessage.message,
          replyBySender: replyBySender,
        ),
        color: repliedMessageConfig?.backgroundColor ?? Colors.grey.shade500,
      ),
      child: _buildMessageTypeContent(replyMessage, textTheme),
    );
  }

  Widget _buildMessageTypeContent(
      ReplyMessage replyMessage, TextTheme textTheme) {
    switch (replyMessage.messageType) {
      case MessageType.image:
      case MessageType.imageFromUrl:
      case MessageType.gif:
        return Container(
          height: repliedMessageConfig?.repliedImageMessageHeight ?? 100,
          width: repliedMessageConfig?.repliedImageMessageWidth ?? 80,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(replyMessage.attachment?.url ?? ''),
              fit: BoxFit.fill,
            ),
            borderRadius:
                repliedMessageConfig?.borderRadius ?? BorderRadius.circular(14),
          ),
        );
      case MessageType.voting:
        return Row(
          children: [
            Icon(
              Icons.poll,
              color: repliedMessageConfig?.micIconColor ?? Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              "Voting",
              style: repliedMessageConfig?.textStyle ??
                  textTheme.bodyMedium!.copyWith(color: Colors.white),
            ),
          ],
        );
      case MessageType.quiz:
        return Row(
          children: [
            Icon(
              Icons.quiz,
              color: repliedMessageConfig?.micIconColor ?? Colors.white,
            ),
          ],
        );
      case MessageType.question:
        return Row(
          children: [
            Icon(
              Icons.question_answer,
              color: repliedMessageConfig?.micIconColor ?? Colors.white,
            ),
          ],
        );

      case MessageType.voice:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.mic,
              color: repliedMessageConfig?.micIconColor ?? Colors.white,
            ),
            const SizedBox(width: 2),
            if (replyMessage.voiceMessageDuration != null)
              Text(
                replyMessage.voiceMessageDuration!.toHHMMSS(),
                style: repliedMessageConfig?.textStyle,
              )
            else
              Text(
                PackageStrings.voiceMessage,
                style: repliedMessageConfig?.textStyle,
              ),
          ],
        );

      case MessageType.video:
      case MessageType.videoFromUrl:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.video_file_outlined,
              color: repliedMessageConfig?.micIconColor ?? Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              PackageStrings.video,
              style: repliedMessageConfig?.textStyle ??
                  textTheme.bodyMedium!.copyWith(color: Colors.white),
            ),
          ],
        );

      case MessageType.file:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FileMessageViewUtils.getFileIcon(
              replyMessage.attachment?.name ?? '',
              iconColor: repliedMessageConfig?.micIconColor ?? Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              replyMessage.attachment?.name ?? '',
              style: repliedMessageConfig?.textStyle ??
                  textTheme.bodyMedium!.copyWith(color: Colors.white),
            ),
          ],
        );

      case MessageType.system:
        return Text(
          replyMessage.message,
          style: repliedMessageConfig?.textStyle ??
              textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
        );

      case MessageType.custom:
        return Text(
          replyMessage.message,
          style: repliedMessageConfig?.textStyle ??
              textTheme.bodyMedium!.copyWith(color: Colors.white),
        );

      case MessageType.text:
        return Text(
          replyMessage.message,
          style: repliedMessageConfig?.textStyle ??
              textTheme.bodyMedium!.copyWith(color: Colors.white),
        );
    }
  }

  BorderRadiusGeometry _borderRadius({
    required String replyMessage,
    required bool replyBySender,
  }) =>
      replyBySender
          ? repliedMessageConfig?.borderRadius ??
              (replyMessage.length < 37
                  ? BorderRadius.circular(replyBorderRadius1)
                  : BorderRadius.circular(replyBorderRadius2))
          : repliedMessageConfig?.borderRadius ??
              (replyMessage.length < 29
                  ? BorderRadius.circular(replyBorderRadius1)
                  : BorderRadius.circular(replyBorderRadius2));
}
