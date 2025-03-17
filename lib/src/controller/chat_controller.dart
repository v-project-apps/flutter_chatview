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

import 'package:chatview/src/widgets/suggestions/suggestion_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class ChatController {
  /// Represents initial message list in chat which can be add by user.
  List<Message> initialMessageList;

  List<Message> pinnedMessageList;

  ScrollController scrollController;

  /// Allow user to show typing indicator defaults to false.
  final ValueNotifier<bool> _showTypingIndicator = ValueNotifier(false);

  /// TypingIndicator as [ValueNotifier] for [GroupedChatList] widget's typingIndicator [ValueListenableBuilder].
  ///  Use this for listening typing indicators
  ///   ```dart
  ///    chatcontroller.typingIndicatorNotifier.addListener((){});
  ///  ```
  /// For more functionalities see [ValueNotifier].
  ValueListenable<bool> get typingIndicatorNotifier => _showTypingIndicator;

  /// Allow user to add reply suggestions defaults to empty.
  final ValueNotifier<List<SuggestionItemData>> _replySuggestion =
      ValueNotifier([]);

  /// newSuggestions as [ValueNotifier] for [SuggestionList] widget's [ValueListenableBuilder].
  ///  Use this to listen when suggestion gets added
  ///   ```dart
  ///    chatcontroller.newSuggestions.addListener((){});
  ///  ```
  /// For more functionalities see [ValueNotifier].
  ValueListenable<List<SuggestionItemData>> get newSuggestions =>
      _replySuggestion;

  /// Getter for typingIndicator value instead of accessing [_showTypingIndicator.value]
  /// for better accessibility.
  bool get showTypingIndicator => _showTypingIndicator.value;

  /// Setter for changing values of typingIndicator
  /// ```dart
  ///  chatContoller.setTypingIndicator = true; // for showing indicator
  ///  chatContoller.setTypingIndicator = false; // for hiding indicator
  ///  ```` Collapse
  set setTypingIndicator(bool value) => _showTypingIndicator.value = value;

  /// Represents list of chat users
  List<ChatUser> otherUsers;

  /// Provides current user which is sending messages.
  final ChatUser currentUser;

  ChatController({
    required this.initialMessageList,
    required this.pinnedMessageList,
    required this.scrollController,
    required this.otherUsers,
    required this.currentUser,
  }) {
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
    }
    if (!pinnedMessageStreamController.isClosed) {
      pinnedMessageStreamController.sink.add(pinnedMessageList);
    }
  }

  /// Represents message stream of chat
  StreamController<List<Message>> messageStreamController = StreamController();

  /// Represents message stream of pinned messages
  StreamController<List<Message>> pinnedMessageStreamController =
      StreamController();

  List<ChatUser> getUsersByIds(List<String> userIds) {
    List<ChatUser> users = [];
    for (var userId in userIds) {
      users.add(getUserFromId(userId));
    }
    return users;
  }

  /// Used to dispose ValueNotifiers and Streams.
  void dispose() {
    _showTypingIndicator.dispose();
    _replySuggestion.dispose();
    scrollController.dispose();
    messageStreamController.close();
    pinnedMessageStreamController.close();
  }

  /// Used to add message in message list.
  void addMessage(Message message) {
    initialMessageList.add(message);
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
    }
  }

  /// Used to add message in message list.
  void addAllMessages(List<Message> messages) {
    initialMessageList.addAll(messages);
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
    }
  }

  void addPinnedMessage(Message message) {
    pinnedMessageList.add(message);
    if (!pinnedMessageStreamController.isClosed) {
      pinnedMessageStreamController.sink.add(pinnedMessageList);
    }
  }

  void addAllPinnedMessages(List<Message> messages) {
    pinnedMessageList.addAll(messages);
    if (!pinnedMessageStreamController.isClosed) {
      pinnedMessageStreamController.sink.add(pinnedMessageList);
    }
  }

  void removePinnedMessage(Message message) {
    pinnedMessageList.remove(message);
    if (!pinnedMessageStreamController.isClosed) {
      pinnedMessageStreamController.sink.add(pinnedMessageList);
    }
  }

  /// Used to add reply suggestions.
  void addReplySuggestions(List<SuggestionItemData> suggestions) {
    _replySuggestion.value = suggestions;
  }

  /// Used to remove reply suggestions.
  void removeReplySuggestions() {
    _replySuggestion.value = [];
  }

  /// Function for setting reaction on specific chat bubble
  void setReaction({
    required String emoji,
    required String messageId,
    required String userId,
  }) {
    final message =
        initialMessageList.firstWhere((element) => element.id == messageId);
    final indexOfMessage = initialMessageList.indexOf(message);
    if (message.reactions.any((reaction) =>
        reaction.name == emoji && reaction.reactedUserId == userId)) {
      message.reactions.removeWhere((reaction) =>
          reaction.name == emoji && reaction.reactedUserId == userId);
    } else {
      message.reactions.add(Reaction(name: emoji, reactedUserId: userId));
    }
    initialMessageList[indexOfMessage] = Message(
      id: messageId,
      message: message.message,
      createdAt: message.createdAt,
      sentBy: message.sentBy,
      replyMessage: message.replyMessage,
      reactions: message.reactions,
      messageType: message.messageType,
      status: message.status,
      seenBy: message.seenBy,
    );
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
    }
  }

  /// Function to scroll to last messages in chat view
  void scrollToLastMessage() => Timer(
        const Duration(milliseconds: 300),
        () {
          if (!scrollController.hasClients) return;
          scrollController.animateTo(
            scrollController.positions.last.minScrollExtent,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 300),
          );
        },
      );

  void scrollToMessage(Message message) {
    final chatMessage =
        initialMessageList.firstWhere((m) => m.id == message.id);

    final key = chatMessage.key;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(context,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: 0.5);
      }
    });
  }

  /// Function for loading data while pagination.
  void loadMoreData(List<Message> messageList) {
    /// Here, we have passed 0 index as we need to add data before first data
    initialMessageList.insertAll(0, messageList);
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
    }
  }

  /// Function for getting ChatUser object from user id
  ChatUser getUserFromId(String userId) => userId == currentUser.id
      ? currentUser
      : otherUsers.firstWhere((element) => element.id == userId);
}
