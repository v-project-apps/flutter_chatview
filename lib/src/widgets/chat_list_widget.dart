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
import 'dart:async';
import 'dart:io' if (kIsWeb) 'dart:html';

import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/widgets/chat_groupedlist_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../chatview.dart';
import 'reply_popup_widget.dart';
import 'pinned_message_widget.dart';

class ChatListWidget extends StatefulWidget {
  const ChatListWidget({
    Key? key,
    required this.chatController,
    required this.assignReplyMessage,
    required this.replyMessage,
    this.loadingWidget,
    this.loadMoreData,
    this.isLastPage,
    this.onChatListTap,
    this.pinnedMessageConfiguration = const PinnedMessageConfiguration(),
    this.onUnpinTap,
    this.onPinTap,
    this.featureActiveConfig,
  }) : super(key: key);

  /// Provides controller for accessing few function for running chat.
  final ChatController chatController;

  /// Provides widget for loading view while pagination is enabled.
  final Widget? loadingWidget;

  /// Provides reply message when user swipe to chat bubble.
  final ReplyMessage replyMessage;

  /// Provides callback when user actions reaches to top and needs to load more
  /// chat
  final VoidCallBackWithFuture? loadMoreData;

  /// Provides flag if there is no more next data left in list.
  final bool? isLastPage;

  /// Provides callback for assigning reply message when user swipe to chat
  /// bubble.
  final MessageCallBack assignReplyMessage;

  /// Provides callback when user tap anywhere on whole chat.
  final VoidCallBack? onChatListTap;

  /// Pinned messages configuration.
  final PinnedMessageConfiguration pinnedMessageConfiguration;

  /// Provides callback when user tap on unpin message.
  final PinTapCallBack? onUnpinTap;

  /// Provides callback when user tap on pin message.
  final PinTapCallBack? onPinTap;

  /// Feature active configuration
  final FeatureActiveConfig? featureActiveConfig;

  @override
  State<ChatListWidget> createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends State<ChatListWidget> {
  final ValueNotifier<bool> _isNextPageLoading = ValueNotifier<bool>(false);
  final ValueNotifier<Message?> _pinnedMessageToHighlight =
      ValueNotifier<Message?>(null);

  ChatController get chatController => widget.chatController;

  List<Message> get messageList => chatController.initialMessageList;

  ScrollController get scrollController => chatController.scrollController;

  FeatureActiveConfig? featureActiveConfig;
  ChatUser? currentUser;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (chatViewIW != null) {
      featureActiveConfig =
          widget.featureActiveConfig ?? chatViewIW!.featureActiveConfig;
      currentUser = chatViewIW!.chatController.currentUser;
    }
    if (featureActiveConfig?.enablePagination ?? false) {
      // When flag is on then it will include pagination logic to scroll
      // controller.
      scrollController.addListener(_pagination);
    }
  }

  void _initialize() {
    chatController.messageStreamController = StreamController();
    if (!chatController.messageStreamController.isClosed) {
      chatController.messageStreamController.sink.add(messageList);
    }
    if (messageList.isNotEmpty) chatController.scrollToLastMessage();

    if (!chatController.pinnedMessageStreamController.isClosed) {
      chatController.pinnedMessageStreamController.sink
          .add(chatController.pinnedMessageList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<List<Message>>(
            stream: widget.chatController.pinnedMessageStreamController.stream,
            builder: (context, snapshot) {
              debugPrint('snapshot.data: ${snapshot.data}');
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!
                      .take(3)
                      .map((message) => PinnedMessageWidget(
                            message: message,
                            onTap: () async {
                              await _onPinnedMessageTap(message);
                            },
                            pinnedMessageConfiguration:
                                widget.pinnedMessageConfiguration,
                            onRemove: () => _removePinnedMessage(message),
                          ))
                      .toList(),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
        ValueListenableBuilder<bool>(
            valueListenable: _isNextPageLoading,
            builder: (_, isNextPageLoading, child) {
              if (isNextPageLoading &&
                  (featureActiveConfig?.enablePagination ?? false)) {
                return SizedBox(
                  height: Scaffold.of(context).appBarMaxHeight,
                  child: Center(
                    child: widget.loadingWidget ??
                        const CircularProgressIndicator(),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: chatViewIW!.showPopUp,
            builder: (_, showPopupValue, child) {
              return ChatGroupedListWidget(
                showPopUp: showPopupValue,
                chatController: widget.chatController,
                isEnableSwipeToSeeTime:
                    featureActiveConfig?.enableSwipeToSeeTime ?? true,
                assignReplyMessage: widget.assignReplyMessage,
                replyMessage: widget.replyMessage,
                onChatBubbleLongPress: (yCoordinate, xCoordinate, message) {
                  if (featureActiveConfig?.enableReactionPopup ?? false) {
                    chatViewIW?.reactionPopupKey.currentState?.refreshWidget(
                      message: message,
                      xCoordinate: xCoordinate,
                      yCoordinate: yCoordinate,
                    );
                    chatViewIW?.showPopUp.value = true;
                  }
                  if (featureActiveConfig?.enableReplySnackBar ?? false) {
                    _showReplyPopup(
                      message: message,
                      sentByCurrentUser: message.sentBy == currentUser?.id,
                    );
                  }
                },
                onChatListTap: _onChatListTap,
                useScrollablePositionedList:
                    featureActiveConfig?.useScrollablePositionedList ?? false,
                onPinnedTap: (message) async {
                  await _onPinnedMessageTap(message);
                },
                pinnedMessageToHighlight: _pinnedMessageToHighlight,
              );
            },
          ),
        ),
      ],
    );
  }

  void _removePinnedMessage(Message message) {
    widget.chatController.removePinnedMessage(message);
    widget.onUnpinTap?.call(message);
  }

  void _pagination() {
    if (widget.loadMoreData == null || widget.isLastPage == true) return;
    if ((scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) &&
        !_isNextPageLoading.value) {
      _isNextPageLoading.value = true;
      widget.loadMoreData!()
          .whenComplete(() => _isNextPageLoading.value = false);
    }
  }

  void _showReplyPopup({
    required Message message,
    required bool sentByCurrentUser,
  }) {
    final replyPopup = chatListConfig.replyPopupConfig;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(hours: 1),
          backgroundColor: replyPopup?.backgroundColor ?? Colors.white,
          content: replyPopup?.replyPopupBuilder != null
              ? replyPopup!.replyPopupBuilder!(message, sentByCurrentUser)
              : ReplyPopupWidget(
                  buttonTextStyle: replyPopup?.buttonTextStyle,
                  topBorderColor: replyPopup?.topBorderColor,
                  onPinTap: widget.pinnedMessageConfiguration.allowPinMessage
                      ? () {
                          _onChatListTap();
                          widget.chatController.addPinnedMessage(message);
                          widget.onPinTap?.call(message);
                          replyPopup?.onPinTap?.call(message);
                        }
                      : null,
                  onReportTap: () {
                    _onChatListTap();
                    replyPopup?.onReportTap?.call(
                      message,
                    );
                  },
                  onUnsendTap: () {
                    _onChatListTap();
                    replyPopup?.onUnsendTap?.call(
                      message,
                    );
                  },
                  onReplyTap: () {
                    widget.assignReplyMessage(message);
                    if (featureActiveConfig?.enableReactionPopup ?? false) {
                      chatViewIW?.showPopUp.value = false;
                    }
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    if (replyPopup?.onReplyTap != null) {
                      replyPopup?.onReplyTap!(message);
                    }
                  },
                  sentByCurrentUser: sentByCurrentUser,
                ),
          padding: EdgeInsets.zero,
        ),
      ).closed;
  }

  void _onChatListTap() {
    widget.onChatListTap?.call();
    if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
      FocusScope.of(context).unfocus();
    }
    chatViewIW?.showPopUp.value = false;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  Future<void> _onPinnedMessageTap(Message message) async {
    // First scroll to the message
    await chatController.scrollToMessage(message);

    // Wait a bit more to ensure scroll animation is completely finished
    await Future.delayed(const Duration(milliseconds: 200));

    // Now trigger highlighting by setting the pinned message
    _pinnedMessageToHighlight.value = message;

    // Clear the highlighting after a delay
    await Future.delayed(const Duration(milliseconds: 1000), () {
      _pinnedMessageToHighlight.value = null;
    });
  }

  @override
  void dispose() {
    chatController.messageStreamController.close();
    chatController.pinnedMessageStreamController.close();
    scrollController.dispose();
    _isNextPageLoading.dispose();
    _pinnedMessageToHighlight.dispose();
    super.dispose();
  }
}
