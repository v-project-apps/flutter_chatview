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
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/widgets/chat_view_inherited_widget.dart';
import 'package:chatview/src/widgets/horizontal_user_avatars.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'reaction_widget.dart';

class QuestionMessageView extends StatefulWidget {
  const QuestionMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
    this.chatBubbleMaxWidth,
    this.messageReactionConfig,
    this.questionMessageConfiguration,
    this.onQuestionSubmitted,
  }) : super(key: key);

  final Message message;
  final bool isMessageBySender;
  final ChatBubble? inComingChatBubbleConfig;
  final ChatBubble? outgoingChatBubbleConfig;
  final double? chatBubbleMaxWidth;
  final MessageReactionConfiguration? messageReactionConfig;
  final QuestionMessageConfiguration? questionMessageConfiguration;
  final Function(String question)? onQuestionSubmitted;

  @override
  State<QuestionMessageView> createState() => _QuestionMessageViewState();
}

class _QuestionMessageViewState extends State<QuestionMessageView> {
  QuestionMessage? _questionMessage;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  QuestionSubmission? _submittedQuestion;
  bool get _isSubmitted => _submittedQuestion != null;

  void _parseQuestionMessage() {
    try {
      // Parse question data from message field as JSON string
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(jsonDecode(widget.message.message));

      // Try to parse as QuestionMessage directly (without type field)
      _questionMessage = QuestionMessage.fromJson(data);
      if (_submittedQuestion == null) {
        String? currentUserId = chatViewIW?.chatController.currentUser.id;
        for (QuestionSubmission submission
            in _questionMessage?.submissions ?? []) {
          if (submission.userId == currentUserId) {
            _submittedQuestion = submission;
            _textController.text = submission.userQuestion;
            break;
          }
        }
      }
    } catch (e) {
      // Handle parsing error
      debugPrint('Error parsing question message: $e');
    }
  }

  @override
  void didChangeDependencies() {
    _parseQuestionMessage();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant QuestionMessageView oldWidget) {
    _parseQuestionMessage();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_questionMessage == null) {
      return const SizedBox.shrink();
    }

    final config = widget.questionMessageConfiguration;
    final chatBubbleConfig = widget.isMessageBySender
        ? widget.outgoingChatBubbleConfig
        : widget.inComingChatBubbleConfig;

    return Stack(clipBehavior: Clip.none, children: [
      Container(
        constraints: BoxConstraints(
          maxWidth: widget.chatBubbleMaxWidth ??
              MediaQuery.of(context).size.width * 0.35,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        child: Container(
          padding: config?.padding ??
              chatBubbleConfig?.padding ??
              const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: config?.backgroundColor ??
                chatBubbleConfig?.color ??
                (widget.isMessageBySender
                    ? Colors.blue[100]
                    : Colors.grey[100]),
            borderRadius: config?.borderRadius ??
                chatBubbleConfig?.borderRadius ??
                BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPromptHeader(config),
              const SizedBox(height: 12),
              _isSubmitted
                  ? _buildSubmittedQuestion(config)
                  : _buildQuestionInput(config),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_isSubmitted &&
                      _submittedQuestion?.submittedAt != null) ...[
                    Text(
                      'Submitted ${_formatTimeAgo(_submittedQuestion!.submittedAt!)}',
                      style: config?.submittedTimeTextStyle ??
                          const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                    ),
                  ],
                  _buildQuestionCount(config),
                ],
              ),
            ],
          ),
        ),
      ),
      if (widget.message.seenBy?.isNotEmpty ?? false)
        Positioned(
          bottom: 0,
          right: widget.isMessageBySender ? 0 : null,
          left: widget.isMessageBySender ? null : 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.7, horizontal: 6),
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
          reactions: widget.message.reactions,
          messageReactionConfig: widget.messageReactionConfig,
          isMessageBySender: widget.isMessageBySender,
        ),
    ]);
  }

  Widget _buildPromptHeader(QuestionMessageConfiguration? config) {
    return Row(
      children: [
        Icon(
          Icons.question_answer,
          size: 20,
          color: config?.questionIconColor ?? Colors.purple[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _questionMessage!.prompt,
            style: config?.promptTextStyle ??
                const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionInput(QuestionMessageConfiguration? config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _textController,
          maxLines: config?.textFieldMaxLines ?? 3,
          decoration: InputDecoration(
            hintText: config?.textFieldHintText ?? 'Type your answer here...',
            filled: true,
            fillColor: config?.textFieldBackgroundColor ?? Colors.white,
            border: OutlineInputBorder(
              borderRadius:
                  config?.textFieldBorderRadius ?? BorderRadius.circular(8),
              borderSide: BorderSide(
                color: config?.textFieldBorderColor ?? Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  config?.textFieldBorderRadius ?? BorderRadius.circular(8),
              borderSide: BorderSide(
                color: config?.textFieldFocusedBorderColor ?? Colors.purple,
              ),
            ),
            contentPadding:
                config?.textFieldPadding ?? const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                // Call the configuration callback if available
                widget.questionMessageConfiguration?.onQuestionCancelled
                    ?.call();
              },
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _submitQuestion(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _textController.text.trim().isEmpty
                    ? config?.submitButtonDisabledBackgroundColor ??
                        Colors.grey[300]
                    : config?.submitButtonBackgroundColor ?? Colors.purple,
                foregroundColor: _textController.text.trim().isEmpty
                    ? config?.submitButtonDisabledTextColor ?? Colors.grey[600]
                    : config?.submitButtonTextColor ?? Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: config?.submitButtonBorderRadius ??
                      BorderRadius.circular(8),
                ),
                padding: config?.submitButtonPadding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Submit',
                style: config?.submitButtonTextStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmittedQuestion(QuestionMessageConfiguration? config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: config?.textFieldBackgroundColor ?? Colors.white,
            borderRadius:
                config?.textFieldBorderRadius ?? BorderRadius.circular(8),
            border: Border.all(
              color: config?.textFieldBorderColor ?? Colors.grey[300]!,
            ),
          ),
          child: Text(
            _submittedQuestion!.userQuestion,
            style: config?.userQuestionTextStyle ??
                const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCount(QuestionMessageConfiguration? config) {
    return Text(
      'Asked ${_questionMessage!.submissions.length} question${_questionMessage!.submissions.length == 1 ? '' : 's'}',
      style: config?.questionCountTextStyle ??
          const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    }
  }

  void _submitQuestion() {
    final question = _textController.text.trim();
    if (question.isNotEmpty) {
      setState(() {
        _submittedQuestion = QuestionSubmission(
          userId: chatViewIW?.chatController.currentUser.id ?? '',
          userQuestion: question,
          submittedAt: DateTime.now(),
        );
      });

      // Call the configuration callback if available
      widget.questionMessageConfiguration?.onQuestionSubmitted
          ?.call(widget.message.id, _submittedQuestion!);

      // Call the legacy callback if available
      widget.onQuestionSubmitted?.call(question);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
