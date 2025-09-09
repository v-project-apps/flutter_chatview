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

/// Direction for loading messages in cursor-based pagination
enum LoadDirection {
  /// Load messages before the cursor (older messages)
  older,

  /// Load messages after the cursor (newer messages)
  newer,

  /// Load messages around the cursor (for jump-to functionality)
  aroundCursor,
}

/// Configuration for pagination behavior
class PaginationConfig {
  const PaginationConfig({
    this.defaultPageSize = 20,
    this.maxPageSize = 50,
    this.minPageSize = 10,
    this.loadThreshold = 0.8,
    this.enableCursorPagination = true,
    this.enableJumpToMessage = true,
    this.enableScrollablePositionedList = true,
  });

  /// Default number of messages to load per page
  final int defaultPageSize;

  /// Maximum number of messages to load per page
  final int maxPageSize;

  /// Minimum number of messages to load per page
  final int minPageSize;

  /// Threshold (0.0 to 1.0) for triggering automatic loading
  /// 0.8 means load when 80% scrolled
  final double loadThreshold;

  /// Enable cursor-based pagination system
  final bool enableCursorPagination;

  /// Enable jump-to message functionality
  final bool enableJumpToMessage;

  /// Use ScrollablePositionedList instead of CustomScrollView
  final bool enableScrollablePositionedList;
}

/// Callback for fetching messages with cursor-based pagination
typedef MessageLoader = Future<List<Message>> Function({
  required LoadDirection direction,
  Message? cursor,
  int limit,
});
