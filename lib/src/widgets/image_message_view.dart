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
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/models/models.dart';
import 'package:chatview/src/widgets/chat_view_inherited_widget.dart';
import 'package:chatview/src/widgets/horizontal_user_avatars.dart';
import 'package:flutter/material.dart';

import 'reaction_widget.dart';
import 'share_icon.dart';

class ImageMessageView extends StatelessWidget {
  const ImageMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    this.imageMessageConfig,
    this.messageReactionConfig,
    this.highlightImage = false,
    this.highlightScale = 1.2,
  }) : super(key: key);

  /// Provides message instance of chat.
  final Message message;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides configuration for image message appearance.
  final ImageMessageConfiguration? imageMessageConfig;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents flag of highlighting image when user taps on replied image.
  final bool highlightImage;

  /// Provides scale of highlighted image when user taps on replied image.
  final double highlightScale;

  String get imageUrl =>
      message.attachment?.url ?? message.attachment?.file?.path ?? "";

  Widget get iconButton => ShareIcon(
        shareIconConfig: imageMessageConfig?.shareIconConfig,
        imageUrl: imageUrl,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          isMessageBySender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isMessageBySender && !(imageMessageConfig?.hideShareIcon ?? false))
          iconButton,
        Stack(
          children: [
            GestureDetector(
              onTap: () => imageMessageConfig?.onTap != null
                  ? imageMessageConfig?.onTap!(message)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Scaffold(
                          backgroundColor: Colors.black,
                          body: Center(
                            child: Hero(
                              tag: imageUrl,
                              child: _imageWidget(),
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
                  padding: imageMessageConfig?.padding ?? EdgeInsets.zero,
                  margin: imageMessageConfig?.margin ??
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
                    maxHeight: imageMessageConfig?.height ?? 360,
                    maxWidth: imageMessageConfig?.width ?? 540,
                  ),
                  // height: imageMessageConfig?.height ?? 200,
                  // width: imageMessageConfig?.width ?? 150,
                  child: ClipRRect(
                    borderRadius: imageMessageConfig?.borderRadius ??
                        BorderRadius.circular(14),
                    child: Hero(
                      tag: imageUrl,
                      child: _imageWidget(),
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
        if (!isMessageBySender && !(imageMessageConfig?.hideShareIcon ?? false))
          iconButton,
      ],
    );
  }

  Widget _imageWidget() {
    if (imageUrl.isUrl) {
      // Handle GIFs differently on web
      if (kIsWeb && imageUrl.toLowerCase().endsWith('.gif')) {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        );
      }

      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        imageBuilder: (context, imageProvider) => Image(
          image: ResizeImage(imageProvider, height: 720),
          fit: BoxFit.cover,
        ),
        progressIndicatorBuilder: (context, child, downloadProgress) {
          return Center(
            child: CircularProgressIndicator(
              value: downloadProgress.progress,
            ),
          );
        },
      );
    } else if (imageUrl.fromMemory) {
      return Image.memory(
        base64Decode(imageUrl.substring(imageUrl.indexOf('base64') + 7)),
        height: 720,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
      );
    } else {
      return Image.file(
        File(imageUrl),
        height: 720,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
      );
    }
  }
}
