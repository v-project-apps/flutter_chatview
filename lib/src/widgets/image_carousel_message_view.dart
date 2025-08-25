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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'reaction_widget.dart';
import 'share_icon.dart';

class ImageCarouselMessageView extends StatefulWidget {
  const ImageCarouselMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    this.imageCarouselMessageConfig,
    this.messageReactionConfig,
    this.highlightImage = false,
    this.highlightScale = 1.2,
    this.highlightColor,
  }) : super(key: key);

  /// Provides message instance of chat.
  final Message message;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides configuration for image carousel message appearance.
  final ImageCarouselMessageConfiguration? imageCarouselMessageConfig;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents flag of highlighting image when user taps on replied image.
  final bool highlightImage;

  /// Provides scale of highlighted image when user taps on replied image.
  final double highlightScale;

  /// Provides color of highlighted image when user taps on replied image.
  final Color? highlightColor;

  @override
  State<ImageCarouselMessageView> createState() =>
      _ImageCarouselMessageViewState();
}

class _ImageCarouselMessageViewState extends State<ImageCarouselMessageView> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> get imageUrls {
    final attachments = widget.message.attachments;
    debugPrint(
        'ImageCarouselMessageView - message attachments: ${attachments?.length ?? 0}');
    if (attachments != null && attachments.isNotEmpty) {
      final urls = attachments.map((attachment) => attachment.url).toList();
      debugPrint('ImageCarouselMessageView - image URLs: $urls');
      return urls;
    }
    debugPrint('ImageCarouselMessageView - no attachments found');
    return [];
  }

  Widget get iconButton => ShareIcon(
        shareIconConfig: widget.imageCarouselMessageConfig?.shareIconConfig,
        imageUrl: imageUrls.isNotEmpty ? imageUrls[0] : "",
      );

  @override
  Widget build(BuildContext context) {
    try {
      debugPrint('ImageCarouselMessageView - build method called');
      final images = imageUrls;
      debugPrint('ImageCarouselMessageView - images count: ${images.length}');
      if (images.isEmpty) {
        debugPrint(
            'ImageCarouselMessageView - no images, returning empty widget');
        return const SizedBox.shrink();
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: widget.isMessageBySender
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (widget.isMessageBySender &&
              !(widget.imageCarouselMessageConfig?.hideShareIcon ?? false))
            iconButton,
          Stack(
            children: [
              GestureDetector(
                onTap: () => widget.imageCarouselMessageConfig?.onTap != null
                    ? widget.imageCarouselMessageConfig?.onTap!(widget.message)
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            backgroundColor: Colors.black,
                            body: Center(
                              child: PageView.builder(
                                itemCount: images.length,
                                allowImplicitScrolling: true,
                                itemBuilder: (context, index) {
                                  return Hero(
                                    tag: '${images[index]}_carousel',
                                    child: ImageContainer(
                                      imageUrl: images[index],
                                      fileBytes: widget.message
                                          .attachments?[index].fileBytes,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                child: Transform.scale(
                  scale: widget.highlightImage ? widget.highlightScale : 1.0,
                  alignment: widget.isMessageBySender
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: widget.imageCarouselMessageConfig?.padding ??
                        EdgeInsets.zero,
                    margin: widget.imageCarouselMessageConfig?.margin ??
                        EdgeInsets.only(
                          top: 6,
                          right: widget.isMessageBySender ? 6 : 0,
                          left: widget.isMessageBySender ? 0 : 6,
                          bottom: widget.message.reactions.isNotEmpty ||
                                  (widget.message.seenBy?.isNotEmpty ?? false)
                              ? 15
                              : 0,
                        ),
                    constraints: BoxConstraints(
                      maxHeight:
                          widget.imageCarouselMessageConfig?.height ?? 360,
                      maxWidth: widget.imageCarouselMessageConfig?.width ?? 540,
                    ),
                    child: ClipRRect(
                      borderRadius:
                          widget.imageCarouselMessageConfig?.borderRadius ??
                              BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: widget.highlightColor,
                          borderRadius:
                              widget.imageCarouselMessageConfig?.borderRadius ??
                                  BorderRadius.circular(14),
                        ),
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                debugPrint(
                                    'ImageCarouselMessageView - building image $index: ${images[index]}');
                                return Container(
                                  height: widget.imageCarouselMessageConfig
                                          ?.imageHeight ??
                                      360,
                                  width: widget.imageCarouselMessageConfig
                                          ?.imageWidth ??
                                      540,
                                  padding: widget.imageCarouselMessageConfig
                                          ?.imagePadding ??
                                      EdgeInsets.zero,
                                  margin: widget.imageCarouselMessageConfig
                                          ?.imageMargin ??
                                      EdgeInsets.zero,
                                  child: ClipRRect(
                                    borderRadius: widget
                                            .imageCarouselMessageConfig
                                            ?.imageBorderRadius ??
                                        BorderRadius.circular(6),
                                    child: ImageContainer(
                                      imageUrl: images[index],
                                      fileBytes: widget.message
                                          .attachments?[index].fileBytes,
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (images.length > 1)
                              Positioned(
                                bottom: 8,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    images.length,
                                    (index) => InkWell(
                                      onTap: () {
                                        _pageController.animateToPage(
                                          index,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      child: Container(
                                        width: widget.imageCarouselMessageConfig
                                                ?.indicatorSize ??
                                            12,
                                        height: widget
                                                .imageCarouselMessageConfig
                                                ?.indicatorSize ??
                                            12,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: widget
                                                  .imageCarouselMessageConfig
                                                  ?.indicatorSpacing ??
                                              4,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: widget.highlightColor ??
                                                Colors.white,
                                            width: 1,
                                          ),
                                          color: index == _currentPage
                                              ? (widget
                                                      .imageCarouselMessageConfig
                                                      ?.indicatorColor ??
                                                  Colors.white)
                                              : (widget
                                                      .imageCarouselMessageConfig
                                                      ?.indicatorBackgroundColor ??
                                                  Colors.white
                                                      .withValues(alpha: 0.5)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
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
              !(widget.imageCarouselMessageConfig?.hideShareIcon ?? false))
            iconButton,
        ],
      );
    } catch (e, stackTrace) {
      debugPrint('Error building ImageCarouselMessageView: $e');
      debugPrint('Stack trace: $stackTrace');
      // Return a fallback widget on error
      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Column(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(height: 8),
            Text(
              'Error displaying image carousel',
              style: TextStyle(color: Colors.red[700]),
            ),
            if (kDebugMode) ...[
              const SizedBox(height: 4),
              Text(
                'Error: $e',
                style: TextStyle(color: Colors.red[600], fontSize: 12),
              ),
            ],
          ],
        ),
      );
    }
  }
}
