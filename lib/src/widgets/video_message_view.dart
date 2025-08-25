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

class VideoMessageView extends StatefulWidget {
  const VideoMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    this.videoMessageConfiguration,
    this.highlightVideo = false,
    this.highlightScale = 1.2,
    this.messageReactionConfig,
  }) : super(key: key);

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

  @override
  State<VideoMessageView> createState() => _VideoMessageViewState();
}

class _VideoMessageViewState extends State<VideoMessageView> {
  String get videoPath =>
      widget.message.attachments?.first.url ??
      widget.message.attachments?.first.file?.path ??
      "";

  String get thumbnailUrl =>
      widget.message.attachments?.first.thumbnailUrl ?? "";

  Widget get iconButton => ShareIcon(
        shareIconConfig: widget.videoMessageConfiguration?.shareIconConfig,
        imageUrl: videoPath,
      );

  Widget? _cachedThumbnail;
  Future<Widget>? _thumbnailFuture;
  String? _lastVideoPath;
  String? _lastThumbnailUrl;

  @override
  void initState() {
    super.initState();
    _lastVideoPath = videoPath;
    _lastThumbnailUrl = thumbnailUrl;
    _initializeThumbnail();
  }

  void _initializeThumbnail() {
    _thumbnailFuture = _generateThumbnail();
  }

  Future<Widget> _generateThumbnail() async {
    try {
      if (thumbnailUrl.isNotEmpty) {
        return Stack(
          children: [
            _videoContainer(CachedNetworkImage(
              imageUrl: thumbnailUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              fit: BoxFit.cover,
              memCacheWidth:
                  (widget.videoMessageConfiguration?.previewWidth ?? 1080)
                      .toInt(),
              memCacheHeight:
                  (widget.videoMessageConfiguration?.previewHeight ?? 720)
                      .toInt(),
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
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
        final file = await VideoThumbnail.thumbnailFile(
          video: videoPath,
          thumbnailPath: kIsWeb ? null : (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.JPEG,
          maxHeight:
              widget.videoMessageConfiguration?.previewHeight?.toInt() ?? 720,
          maxWidth:
              widget.videoMessageConfiguration?.previewWidth?.toInt() ?? 1080,
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
                    memCacheWidth:
                        (widget.videoMessageConfiguration?.previewWidth ?? 1080)
                            .toInt(),
                    memCacheHeight:
                        (widget.videoMessageConfiguration?.previewHeight ?? 720)
                            .toInt(),
                    fadeInDuration: Duration.zero,
                    fadeOutDuration: Duration.zero,
                  )
                : Image.file(
                    File(file.path),
                    fit: BoxFit.cover,
                    cacheWidth:
                        (widget.videoMessageConfiguration?.previewWidth ?? 1080)
                            .toInt(),
                    cacheHeight:
                        (widget.videoMessageConfiguration?.previewHeight ?? 720)
                            .toInt(),
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
    } catch (e) {
      debugPrint(e.toString());
      return Stack(
        children: [
          _videoContainer(const SizedBox()),
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: widget.isMessageBySender
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (widget.isMessageBySender &&
              !(widget.videoMessageConfiguration?.hideShareIcon ?? false))
            iconButton,
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  widget.videoMessageConfiguration?.onTap != null
                      ? widget.videoMessageConfiguration?.onTap!(widget.message)
                      : Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Material(child: VideoPlayer(videoUrl: videoPath)),
                        ));
                },
                child: Transform.scale(
                  scale: widget.highlightVideo ? widget.highlightScale : 1.0,
                  alignment: widget.isMessageBySender
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: widget.videoMessageConfiguration?.padding ??
                        EdgeInsets.zero,
                    margin: widget.videoMessageConfiguration?.margin ??
                        EdgeInsets.only(
                          top: 6,
                          right: widget.isMessageBySender ? 6 : 0,
                          left: widget.isMessageBySender ? 0 : 6,
                          bottom: widget.message.reactions.isNotEmpty ||
                                  (widget.message.seenBy?.isNotEmpty ?? false)
                              ? 15
                              : 0,
                        ),
                    child: ClipRRect(
                      borderRadius:
                          widget.videoMessageConfiguration?.borderRadius ??
                              BorderRadius.circular(14),
                      child: FutureBuilder(
                          future: _thumbnailFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _videoContainer(
                                  const CircularProgressIndicator());
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              _cachedThumbnail = snapshot.data as Widget;
                              return _cachedThumbnail!;
                            } else {
                              return Container();
                            }
                          }),
                    ),
                  ),
                ),
              ),
              if (widget.message.seenBy?.isNotEmpty ?? false)
                Positioned(
                  bottom: 0,
                  right: widget.isMessageBySender ? 0 : null,
                  left: widget.isMessageBySender ? null : 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 1.7, horizontal: 6),
                    child: HorizontalUserAvatars(
                      users: ChatViewInheritedWidget.of(context)
                              ?.chatController
                              .getUsersByIds(widget.message.seenBy!) ??
                          [],
                      circleRadius: 8,
                    ),
                  ),
                ),
              if (widget.message.reactions.isNotEmpty)
                ReactionWidget(
                  isMessageBySender: widget.isMessageBySender,
                  reactions: widget.message.reactions,
                  messageReactionConfig: widget.messageReactionConfig,
                ),
            ],
          ),
          if (!widget.isMessageBySender &&
              !(widget.videoMessageConfiguration?.hideShareIcon ?? false))
            iconButton,
        ],
      ),
    );
  }

  Widget _videoContainer(Widget child) => Container(
      height: widget.videoMessageConfiguration?.previewHeight ?? 720,
      width: widget.videoMessageConfiguration?.previewWidth ?? 1080,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
      ),
      child: Center(child: child));

  @override
  void didUpdateWidget(VideoMessageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only regenerate thumbnail if video path or thumbnail URL changes
    if (videoPath != _lastVideoPath || thumbnailUrl != _lastThumbnailUrl) {
      _lastVideoPath = videoPath;
      _lastThumbnailUrl = thumbnailUrl;
      _initializeThumbnail();
    }
  }
}
