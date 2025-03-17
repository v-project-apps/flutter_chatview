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
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatview/chatview.dart';
import 'package:chatview/src/widgets/chat_view_inherited_widget.dart';
import 'package:chatview/src/widgets/horizontal_user_avatars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

import 'reaction_widget.dart';
import 'share_icon.dart';

class VideoMessageView extends StatelessWidget {
  const VideoMessageView(
      {Key? key,
      required this.message,
      required this.isMessageBySender,
      this.videoMessageConfiguration,
      this.highlightVideo = false,
      this.highlightScale = 1.2,
      this.messageReactionConfig})
      : super(key: key);

  /// Provides message instance of chat.
  final Message message;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides configuration for image message appearance.
  final VideoMessageConfiguration? videoMessageConfiguration;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents flag of highlighting video when user taps on replied video.
  final bool highlightVideo;

  /// Provides scale of highlighted video when user taps on replied video.
  final double highlightScale;

  String get videoPath =>
      message.attachment?.url ?? message.attachment?.file?.path ?? "";

  String get thumbnailUrl => message.attachment?.thumbnailUrl ?? "";

  Widget get iconButton => ShareIcon(
        shareIconConfig: videoMessageConfiguration?.shareIconConfig,
        imageUrl: videoPath,
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            isMessageBySender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMessageBySender &&
              !(videoMessageConfiguration?.hideShareIcon ?? false))
            iconButton,
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  videoMessageConfiguration?.onTap != null
                      ? videoMessageConfiguration?.onTap!(message)
                      : Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Material(child: VideoPlayer(videoUrl: videoPath)),
                        ));
                },
                child: Transform.scale(
                  scale: highlightVideo ? highlightScale : 1.0,
                  alignment: isMessageBySender
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding:
                        videoMessageConfiguration?.padding ?? EdgeInsets.zero,
                    margin: videoMessageConfiguration?.margin ??
                        EdgeInsets.only(
                          top: 6,
                          right: isMessageBySender ? 6 : 0,
                          left: isMessageBySender ? 0 : 6,
                          bottom: message.reactions.isNotEmpty ||
                                  (message.seenBy?.isNotEmpty ?? false)
                              ? 15
                              : 0,
                        ),
                    child: ClipRRect(
                      borderRadius: videoMessageConfiguration?.borderRadius ??
                          BorderRadius.circular(14),
                      child: FutureBuilder(
                          future: getVideoPreview(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _videoContainer(
                                  const CircularProgressIndicator());
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return snapshot.data as Widget;
                            } else {
                              return Container();
                            }
                          }),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 1.7, horizontal: 6),
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
              !(videoMessageConfiguration?.hideShareIcon ?? false))
            iconButton,
        ],
      ),
    );
  }

  Widget _videoContainer(Widget child) => Container(
      height: videoMessageConfiguration?.previewHeight ?? 720,
      width: videoMessageConfiguration?.previewWidth ?? 1080,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      child: Center(child: child));

  Future<Widget> getVideoPreview() async {
    if (message.messageType == MessageType.videoFromUrl) {
      if (thumbnailUrl.isNotEmpty) {
        return Stack(
          children: [
            _videoContainer(CachedNetworkImage(
              imageUrl: thumbnailUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              fit: BoxFit.cover,
            )),
            const Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              top: 0,
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 48,
              ),
            ),
          ],
        );
      } else {
        return _videoContainer(Container(
          color: Colors.black,
        ));
      }
    } else {
      final file = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: kIsWeb ? null : (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: videoMessageConfiguration?.previewHeight?.toInt() ?? 720,
        maxWidth: videoMessageConfiguration?.previewWidth?.toInt() ?? 1080,
        quality: 100,
      );

      return Stack(
        children: [
          _videoContainer(kIsWeb
              ? CachedNetworkImage(
                  imageUrl: file.path,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(file.path),
                  fit: BoxFit.cover,
                )),
          const Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            top: 0,
            child: Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 48,
            ),
          ),
        ],
      );
    }
  }
}
