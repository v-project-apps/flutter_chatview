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
import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

class CursorPaginationExample extends StatefulWidget {
  const CursorPaginationExample({Key? key}) : super(key: key);

  @override
  State<CursorPaginationExample> createState() =>
      _CursorPaginationExampleState();
}

class _CursorPaginationExampleState extends State<CursorPaginationExample> {
  late ChatController chatController;
  late List<Message> initialMessages;
  late List<Message> pinnedMessages;
  late ChatUser currentUser;
  late List<ChatUser> otherUsers;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupChatController();
  }

  void _initializeData() {
    // Initialize users
    currentUser = ChatUser(
      id: '1',
      name: 'You',
      profilePhoto: 'https://i.pravatar.cc/150?img=1',
    );

    otherUsers = [
      ChatUser(
        id: '2',
        name: 'John Doe',
        profilePhoto: 'https://i.pravatar.cc/150?img=2',
      ),
      ChatUser(
        id: '3',
        name: 'Jane Smith',
        profilePhoto: 'https://i.pravatar.cc/150?img=3',
      ),
    ];

    // Initialize some sample messages
    initialMessages = _generateSampleMessages(20);
    pinnedMessages = [
      initialMessages[5],
      initialMessages[10]
    ]; // Pin some messages
  }

  void _setupChatController() {
    chatController = ChatController(
      initialMessageList: initialMessages,
      pinnedMessageList: pinnedMessages,
      otherUsers: otherUsers,
      currentUser: currentUser,
      messageLoader: _messageLoader,
      paginationConfig: const PaginationConfig(
        defaultPageSize: 20,
        enableCursorPagination: true,
        enableJumpToMessage: true,
        enableScrollablePositionedList: true,
      ),
    );
  }

  /// Message loader callback for cursor-based pagination
  Future<List<Message>> _messageLoader({
    required LoadDirection direction,
    Message? cursor,
    int limit = 20,
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    switch (direction) {
      case LoadDirection.older:
        return _loadOlderMessages(cursor, limit);
      case LoadDirection.newer:
        return _loadNewerMessages(cursor, limit);
      case LoadDirection.aroundCursor:
        return _loadMessagesAround(cursor, limit);
    }
  }

  /// Load older messages (before cursor)
  List<Message> _loadOlderMessages(Message? cursor, int limit) {
    final allMessages = _generateAllMessages();

    if (cursor == null) {
      // Load the oldest messages
      return allMessages.take(limit).toList();
    }

    // Find the cursor message and load messages before it
    final cursorIndex = allMessages.indexWhere((msg) => msg.id == cursor.id);
    if (cursorIndex == -1) return [];

    // If we're at the beginning, return empty list
    if (cursorIndex <= 0) return [];

    final startIndex = (cursorIndex - limit).clamp(0, allMessages.length);
    return allMessages.sublist(startIndex, cursorIndex);
  }

  /// Load newer messages (after cursor)
  List<Message> _loadNewerMessages(Message? cursor, int limit) {
    final allMessages = _generateAllMessages();

    if (cursor == null) {
      // Load the newest messages
      return allMessages.reversed.take(limit).toList();
    }

    // Find the cursor message and load messages after it
    final cursorIndex = allMessages.indexWhere((msg) => msg.id == cursor.id);
    if (cursorIndex == -1) return [];

    // If we're at the end, return empty list
    if (cursorIndex >= allMessages.length - 1) return [];

    final endIndex = (cursorIndex + limit + 1).clamp(0, allMessages.length);
    return allMessages.sublist(cursorIndex + 1, endIndex);
  }

  /// Load messages around cursor (for jump-to functionality)
  List<Message> _loadMessagesAround(Message? cursor, int limit) {
    final allMessages = _generateAllMessages();

    if (cursor == null) return [];

    // Find the cursor message
    final cursorIndex = allMessages.indexWhere((msg) => msg.id == cursor.id);
    if (cursorIndex == -1) return [];

    // Load messages around the cursor (half before, half after)
    final halfLimit = (limit / 2).round();
    final startIndex = (cursorIndex - halfLimit).clamp(0, allMessages.length);
    final endIndex = (cursorIndex + halfLimit + 1).clamp(0, allMessages.length);

    return allMessages.sublist(startIndex, endIndex);
  }

  /// Generate sample messages for demonstration
  List<Message> _generateSampleMessages(int count) {
    final messages = <Message>[];
    final now = DateTime.now();

    for (int i = 0; i < count; i++) {
      final messageId = 'msg_${i + 1}';
      final createdAt = now.subtract(Duration(minutes: (count - i) * 5));
      final senderId = i % 3 == 0 ? '1' : (i % 3 == 1 ? '2' : '3');

      messages.add(Message(
        id: messageId,
        message:
            'This is message number ${i + 1}. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        createdAt: createdAt,
        sentBy: senderId,
        messageType: MessageType.text,
        isPinned: i == 5 || i == 10, // Pin some messages
      ));
    }

    return messages;
  }

  /// Generate all messages for simulation
  List<Message> _generateAllMessages() {
    final messages = <Message>[];
    final now = DateTime.now();

    // Generate 1000 messages for simulation
    for (int i = 0; i < 1000; i++) {
      final messageId = 'msg_${i + 1}';
      final createdAt = now.subtract(Duration(minutes: (1000 - i) * 5));
      final senderId = i % 3 == 0 ? '1' : (i % 3 == 1 ? '2' : '3');

      messages.add(Message(
        id: messageId,
        message:
            'This is message number ${i + 1}. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        createdAt: createdAt,
        sentBy: senderId,
        messageType: MessageType.text,
        isPinned: i % 50 == 0, // Pin every 50th message
      ));
    }

    return messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cursor Pagination Example'),
        actions: [
          // Button to jump to a pinned message
          IconButton(
            icon: const Icon(Icons.push_pin),
            onPressed: () => _showPinnedMessagesDialog(),
          ),
        ],
      ),
      body: ChatView(
        chatController: chatController,
        chatViewState: ChatViewState.hasMessages,
        featureActiveConfig: const FeatureActiveConfig(
          enableCursorPagination: true,
          enableJumpToMessage: true,
          useScrollablePositionedList: true,
          enablePagination: false, // Disable old pagination
          enableReactionPopup: true,
          enableReplySnackBar: true,
          enableSwipeToSeeTime: true,
        ),
        paginationConfig: const PaginationConfig(
          defaultPageSize: 20,
          enableCursorPagination: true,
          enableJumpToMessage: true,
          enableScrollablePositionedList: true,
        ),
        repliedMessageConfig: RepliedMessageConfiguration(
          repliedMsgAutoScrollConfig: RepliedMsgAutoScrollConfig(
            enableHighlightRepliedMsg: true,
            enableScrollToRepliedMsg: true,
            highlightColor: Colors.pinkAccent.shade100,
            highlightScale: 1.1,
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.25,
          ),
        ),
        onSendTap: (message) {
          // Handle sending message
          chatController.addMessage(message);
        },
        pinnedMessageConfiguration: const PinnedMessageConfiguration(
          allowPinMessage: true,
        ),
        onPinTap: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pinned: ${message.message}')),
          );
        },
        onUnPinTap: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unpinned: ${message.message}')),
          );
        },
      ),
    );
  }

  void _showPinnedMessagesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Jump to Pinned Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: pinnedMessages.map((message) {
            return ListTile(
              title: Text(message.message.length > 50
                  ? '${message.message.substring(0, 50)}...'
                  : message.message),
              subtitle: Text('Sent by: ${_getUserName(message.sentBy)}'),
              onTap: () {
                Navigator.pop(context);
                chatController.scrollToMessage(message);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getUserName(String userId) {
    if (userId == currentUser.id) return currentUser.name;
    final user =
        otherUsers.firstWhere((u) => u.id == userId, orElse: () => currentUser);
    return user.name;
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }
}
