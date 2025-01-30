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

import 'package:chatview/src/models/config_models/video_message_configuration.dart';
import 'package:chatview/src/models/models.dart';
import 'package:chatview/src/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'reaction_widget.dart';
import 'share_icon.dart';

class VideoMessageView extends StatelessWidget {
  const VideoMessageView(
      {Key? key,
      required this.message,
      required this.isMessageBySender,
      this.videoMessageConfiguration,
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

  String get videoPath => message.message;

  Widget get iconButton => ShareIcon(
        shareIconConfig: videoMessageConfiguration?.shareIconConfig,
        imageUrl: videoPath,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
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
                        builder: (context) => VideoPlayer(videoUrl: videoPath),
                      ));
              },
              child: FutureBuilder(
                  future: getVideoPreview(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return snapshot.data as Widget;
                    } else {
                      return Container();
                    }
                  }),
            ),
            if (message.reaction.reactions.isNotEmpty)
              ReactionWidget(
                isMessageBySender: isMessageBySender,
                reaction: message.reaction,
                messageReactionConfig: messageReactionConfig,
              ),
          ],
        ),
        if (!isMessageBySender &&
            !(videoMessageConfiguration?.hideShareIcon ?? false))
          iconButton,
      ],
    );
  }

  Future<Widget> getVideoPreview() async {
    final filePath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: videoMessageConfiguration?.previewHeight?.toInt() ?? 720,
      maxWidth: videoMessageConfiguration?.previewWidth?.toInt() ?? 1080,
      quality: 75,
    );
    if (filePath != null) {
      return Stack(
        children: [
          Image.file(
            File(filePath),
            fit: BoxFit.cover,
          ),
          const Center(
            child: Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 50,
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
