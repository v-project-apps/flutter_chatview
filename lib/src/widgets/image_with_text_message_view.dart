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
import 'package:chatview/src/widgets/image_container.dart';

import 'package:chatview/src/models/models.dart';
import 'package:chatview/src/widgets/chat_view_inherited_widget.dart';
import 'package:chatview/src/widgets/horizontal_user_avatars.dart';
import 'package:flutter/material.dart';

import 'reaction_widget.dart';
import 'share_icon.dart';

class ImageWithTextMessageView extends StatelessWidget {
  const ImageWithTextMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    this.imageWithTextMessageConfig,
    this.messageReactionConfig,
    this.highlightImage = false,
    this.highlightScale = 1.2,
    this.highlightColor,
  }) : super(key: key);

  /// Provides message instance of chat.
  final Message message;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides configuration for image with text message appearance.
  final ImageWithTextMessageConfiguration? imageWithTextMessageConfig;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents flag of highlighting image when user taps on replied image.
  final bool highlightImage;

  /// Provides scale of highlighted image when user taps on replied image.
  final double highlightScale;

  final Color? highlightColor;

  String get imageUrl =>
      message.attachments?.first.url ??
      message.attachments?.first.file?.path ??
      "";

  String get messageText => message.message;

  Widget get iconButton => ShareIcon(
        shareIconConfig: imageWithTextMessageConfig?.shareIconConfig,
        imageUrl: imageUrl,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isMessageBySender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isMessageBySender &&
            !(imageWithTextMessageConfig?.hideShareIcon ?? false))
          iconButton,
        Stack(
          children: [
            GestureDetector(
              onTap: () => imageWithTextMessageConfig?.onTap != null
                  ? imageWithTextMessageConfig?.onTap!(message)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          backgroundColor: Colors.black,
                          body: Center(
                            child: Hero(
                              tag: imageUrl,
                              child: ImageContainer(
                                imageUrl: imageUrl,
                                fileBytes: message.attachments?.first.fileBytes,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              child: Transform.scale(
                scale: highlightImage ? highlightScale : 1.0,
                alignment: isMessageBySender
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  padding:
                      imageWithTextMessageConfig?.padding ?? EdgeInsets.zero,
                  margin: imageWithTextMessageConfig?.margin ??
                      EdgeInsets.only(
                        top: 6,
                        right: isMessageBySender ? 6 : 0,
                        left: isMessageBySender ? 0 : 6,
                        bottom: message.reactions.isNotEmpty ||
                                (message.seenBy?.isNotEmpty ?? false)
                            ? 15
                            : 0,
                      ),
                  constraints: BoxConstraints(
                    maxWidth: imageWithTextMessageConfig?.width ?? 540,
                    minHeight: 0, // Allow container to shrink if needed
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: highlightColor,
                      borderRadius: imageWithTextMessageConfig?.borderRadius ??
                          BorderRadius.circular(14),
                    ),
                    child: ClipRRect(
                      borderRadius: imageWithTextMessageConfig?.borderRadius ??
                          BorderRadius.circular(6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Flexible(
                            child: Hero(
                              tag: imageUrl,
                              child: ImageContainer(
                                imageUrl: imageUrl,
                                fileBytes: message.attachments?.first.fileBytes,
                                height:
                                    280, // Reduced height to leave room for text
                              ),
                            ),
                          ),
                          if (messageText.isNotEmpty) ...[
                            Flexible(
                              fit: FlexFit.loose,
                              child: Container(
                                width: double.infinity,
                                padding:
                                    imageWithTextMessageConfig?.textPadding ??
                                        const EdgeInsets.all(12),
                                margin:
                                    imageWithTextMessageConfig?.textMargin ??
                                        EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  color: highlightColor ??
                                      imageWithTextMessageConfig
                                          ?.textBackgroundColor ??
                                      Colors.grey[100],
                                  borderRadius: imageWithTextMessageConfig
                                          ?.textBorderRadius ??
                                      const BorderRadius.only(
                                        bottomLeft: Radius.circular(14),
                                        bottomRight: Radius.circular(14),
                                      ),
                                ),
                                child: Text(
                                  messageText,
                                  style:
                                      imageWithTextMessageConfig?.textStyle ??
                                          Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (message.seenBy?.isNotEmpty ?? false)
              Positioned(
                bottom: 0,
                right: isMessageBySender ? 0 : null,
                left: isMessageBySender ? null : 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1.7, horizontal: 6),
                  child: HorizontalUserAvatars(
                    users: ChatViewInheritedWidget.of(context)
                            ?.chatController
                            .getUsersByIds(message.seenBy!) ??
                        [],
                    circleRadius: 8,
                  ),
                ),
              ),
            if (message.reactions.isNotEmpty)
              ReactionWidget(
                isMessageBySender: isMessageBySender,
                reactions: message.reactions,
                messageReactionConfig: messageReactionConfig,
              ),
          ],
        ),
        if (!isMessageBySender &&
            !(imageWithTextMessageConfig?.hideShareIcon ?? false))
          iconButton,
      ],
    );
  }
}
