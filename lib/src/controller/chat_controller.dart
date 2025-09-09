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
import 'dart:developer';

import 'package:chatview/src/widgets/suggestions/suggestion_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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

  final ValueNotifier<Axis> _replySuggestionsDirection =
      ValueNotifier(Axis.vertical);

  /// newSuggestions as [ValueNotifier] for [SuggestionList] widget's [ValueListenableBuilder].
  ///  Use this to listen when suggestion gets added
  ///   ```dart
  ///    chatcontroller.newSuggestions.addListener((){});
  ///  ```
  /// For more functionalities see [ValueNotifier].
  ValueListenable<List<SuggestionItemData>> get newSuggestions =>
      _replySuggestion;

  ValueListenable<Axis> get replySuggestionsDirection =>
      _replySuggestionsDirection;

  /// Getter for typingIndicator value instead of accessing [_showTypingIndicator.value]
  /// for better accessibility.
  bool get showTypingIndicator => _showTypingIndicator.value;

  /// Public getters for loading states
  ValueListenable<bool> get isLoadingOlder => _isLoadingOlderNotifier;
  ValueListenable<bool> get isLoadingNewer => _isLoadingNewerNotifier;
  AutoScrollController get autoScrollController => _autoScrollController;

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

  /// Callback for fetching messages with cursor-based pagination
  final MessageLoader? messageLoader;

  /// Configuration for pagination behavior
  final PaginationConfig paginationConfig;

  /// Cursor state management
  Message? _oldestMessage;
  Message? _newestMessage;
  bool _isLoadingOlder = false;
  bool _isLoadingNewer = false;
  bool _hasMoreOlder = true;
  bool _hasMoreNewer = true;

  /// AutoScrollController for ListView.builder
  late AutoScrollController _autoScrollController;

  /// Loading state notifiers
  final ValueNotifier<bool> _isLoadingOlderNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _isLoadingNewerNotifier = ValueNotifier(false);

  ChatController({
    required this.initialMessageList,
    required this.pinnedMessageList,
    required this.otherUsers,
    required this.currentUser,
    this.messageLoader,
    this.paginationConfig = const PaginationConfig(),
    ScrollController? scrollController,
  }) : scrollController = scrollController ?? ScrollController() {
    _autoScrollController = AutoScrollController();
    _initializeCursorState();

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
    _replySuggestionsDirection.dispose();
    _isLoadingOlderNotifier.dispose();
    _isLoadingNewerNotifier.dispose();
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

  void replaceMessage(Message message) {
    final index =
        initialMessageList.indexWhere((element) => element.id == message.id);
    if (index != -1) {
      initialMessageList[index] = message;
    }
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
    }
  }

  void replaceAllMessages(List<Message> messages) {
    for (final message in messages) {
      final index =
          initialMessageList.indexWhere((element) => element.id == message.id);
      if (index != -1) {
        initialMessageList[index] = message;
      }
    }
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
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

  void setReplySuggestionsDirection(Axis direction) {
    _replySuggestionsDirection.value = direction;
  }

  /// Function for setting reaction on specific chat bubble
  void setReaction({
    required String emoji,
    required String messageId,
    required String userId,
  }) {
    final message = initialMessageList
        .cast<Message?>()
        .firstWhere((element) => element?.id == messageId, orElse: () => null);
    if (message != null) {
      final indexOfMessage = initialMessageList.indexOf(message);
      if (message.reactions.any((reaction) =>
          reaction.emoji == emoji && reaction.reactedUserId == userId)) {
        message.reactions.removeWhere((reaction) =>
            reaction.emoji == emoji && reaction.reactedUserId == userId);
      } else {
        message.reactions.add(Reaction(emoji: emoji, reactedUserId: userId));
      }
      initialMessageList[indexOfMessage] = Message(
        id: messageId,
        message: message.message,
        createdAt: message.createdAt,
        sentBy: message.sentBy,
        replyMessage: message.replyMessage,
        reactions: message.reactions,
        messageType: message.messageType,
        attachments: message.attachments,
        voiceMessageDuration: message.voiceMessageDuration,
        isPinned: message.isPinned,
        status: message.status,
        seenBy: message.seenBy,
        mentions: message.mentions,
      );
    }
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
    }
  }

  /// Function to scroll to last messages in chat view
  void scrollToLastMessage() => Timer(
        const Duration(milliseconds: 300),
        () {
          if (!scrollController.hasClients) return;
          if (scrollController.positions.isEmpty) return;

          final lastPosition = scrollController.positions.last;

          scrollController.animateTo(
            lastPosition.minScrollExtent,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 300),
          );
        },
      );

  /// Function for getting ChatUser object from user id
  ChatUser getUserFromId(String userId) => userId == currentUser.id
      ? currentUser
      : otherUsers.firstWhere((element) => element.id == userId,
          orElse: () => throw Exception('User not found'));

  /// Jump to a specific message by ID
  Future<void> scrollToMessage(Message message) async {
    if (!paginationConfig.enableJumpToMessage || messageLoader == null) {
      return;
    }

    if (initialMessageList.any((element) => element.id == message.id)) {
      await _scrollToMessageById(message.id);
      return;
    }

    // Clear current messages
    initialMessageList.clear();
    _hasMoreOlder = true;
    _hasMoreNewer = true;

    // Load messages around the target message
    final messages = await messageLoader!(
      direction: LoadDirection.aroundCursor,
      cursor: message,
      limit: paginationConfig.defaultPageSize,
    );

    // Update message list
    initialMessageList.addAll(messages);
    _updateCursorState();

    // Notify UI
    if (!messageStreamController.isClosed) {
      messageStreamController.sink.add(initialMessageList);
    }

    // Wait for UI to update, then scroll to the target message
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _scrollToMessageById(message.id);
    });
  }

  /// Load older messages (scrolling up)
  Future<void> loadOlderMessages() async {
    if (_isLoadingOlder || !_hasMoreOlder || messageLoader == null) {
      return;
    }
    _updateCursorState();
    _isLoadingOlder = true;
    _isLoadingOlderNotifier.value = true;
    try {
      final messages = await messageLoader!(
        direction: LoadDirection.older,
        cursor: _oldestMessage,
        limit: paginationConfig.defaultPageSize,
      );

      if (messages.isNotEmpty) {
        // Insert at beginning to maintain chronological order
        initialMessageList.addAll(messages.reversed.toList());
        _updateCursorState();

        // Notify UI
        if (!messageStreamController.isClosed) {
          messageStreamController.sink.add(initialMessageList);
        }
      } else {
        log("no more older messages");
        _hasMoreOlder = false;
      }
    } catch (e) {
      // Handle any errors and stop loading
      _hasMoreOlder = false;
    } finally {
      _isLoadingOlder = false;
      _isLoadingOlderNotifier.value = false;
    }
  }

  /// Load newer messages (scrolling down)
  Future<void> loadNewerMessages() async {
    if (_isLoadingNewer || !_hasMoreNewer || messageLoader == null) {
      return;
    }
    _updateCursorState();
    _isLoadingNewer = true;
    _isLoadingNewerNotifier.value = true;
    try {
      final messages = await messageLoader!(
        direction: LoadDirection.newer,
        cursor: _newestMessage,
        limit: paginationConfig.defaultPageSize,
      );
      double maxScrollExtentBeforeLoading =
          _autoScrollController.positions.last.maxScrollExtent;
      if (messages.isNotEmpty) {
        // Append to end
        initialMessageList.addAll(messages);
        _updateCursorState();

        // Notify UI
        if (!messageStreamController.isClosed) {
          messageStreamController.sink.add(initialMessageList);
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          double maxScrollExtentAfterLoading =
              _autoScrollController.positions.last.maxScrollExtent;
          _autoScrollController.jumpTo(
              maxScrollExtentAfterLoading - maxScrollExtentBeforeLoading);
        });
      } else {
        log("no more newer messages");
        _hasMoreNewer = false;
      }
    } catch (e) {
      // Handle any errors and stop loading
      _hasMoreNewer = false;
    } finally {
      _isLoadingNewer = false;
      _isLoadingNewerNotifier.value = false;
    }
  }

  /// Initialize cursor state from current messages
  void _initializeCursorState() {
    if (initialMessageList.isNotEmpty) {
      // Sort messages by creation time
      initialMessageList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      _updateCursorState();
    }
  }

  /// Update cursor state after message list changes
  void _updateCursorState() {
    initialMessageList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (initialMessageList.isNotEmpty) {
      _oldestMessage = initialMessageList.first;
      _newestMessage = initialMessageList.last;
    }
  }

  /// Scroll to message by ID using AutoScrollController
  Future<void> _scrollToMessageById(String messageId) async {
    final index = initialMessageList.reversed
        .toList()
        .indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      await _autoScrollController.scrollToIndex(
        index,
        duration: const Duration(milliseconds: 500),
        preferPosition: AutoScrollPosition.middle,
      );
    }
  }
}
