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

class QuizMessageView extends StatefulWidget {
  const QuizMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    required this.inComingChatBubbleConfig,
    required this.outgoingChatBubbleConfig,
    this.chatBubbleMaxWidth,
    this.messageReactionConfig,
    this.quizMessageConfiguration,
    this.onAnswerSubmitted,
  }) : super(key: key);

  final Message message;
  final bool isMessageBySender;
  final ChatBubble? inComingChatBubbleConfig;
  final ChatBubble? outgoingChatBubbleConfig;
  final double? chatBubbleMaxWidth;
  final MessageReactionConfiguration? messageReactionConfig;
  final QuizMessageConfiguration? quizMessageConfiguration;
  final Function(String messageId, String optionId, bool isCorrect)?
      onAnswerSubmitted;

  @override
  State<QuizMessageView> createState() => _QuizMessageViewState();
}

class _QuizMessageViewState extends State<QuizMessageView> {
  QuizMessage? _quizMessage;
  bool _isAnswered = false;
  String? _selectedOptionId;

  void _parseQuizMessage() {
    try {
      // Parse quiz data from message field as JSON string
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(jsonDecode(widget.message.message));

      // Try to parse as QuizMessage directly (without type field)
      _quizMessage = QuizMessage.fromJson(data);
      if (_selectedOptionId == null) {
        String? currentUserId = chatViewIW?.chatController.currentUser.id;
        for (QuizOption option in _quizMessage?.options ?? []) {
          if (option.voters.contains(currentUserId)) {
            _selectedOptionId = option.id;
            break;
          }
        }
      }
      _isAnswered = _selectedOptionId != null;
    } catch (e) {
      // Handle parsing error
      debugPrint('Error parsing quiz message: $e');
    }
  }

  @override
  void didChangeDependencies() {
    _parseQuizMessage();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant QuizMessageView oldWidget) {
    _parseQuizMessage();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_quizMessage == null) {
      return const SizedBox.shrink();
    }

    final config = widget.quizMessageConfiguration;
    final chatBubbleConfig = widget.isMessageBySender
        ? widget.outgoingChatBubbleConfig
        : widget.inComingChatBubbleConfig;

    return Stack(
      clipBehavior: Clip.none,
      children: [
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
                _buildQuestionHeader(config),
                const SizedBox(height: 12),
                _buildQuizOptions(config),
                if (_isAnswered && _quizMessage!.explanation != null) ...[
                  const SizedBox(height: 12),
                  _buildExplanation(config),
                ],
                const SizedBox(height: 12),
                _buildAnswersCount(config),
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
        if (widget.quizMessageConfiguration?.showDetailsButton ?? false)
          Positioned(
            top: 0,
            right: widget.isMessageBySender ? null : 0,
            left: widget.isMessageBySender ? 0 : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: IconButton(
                onPressed: () {
                  widget.quizMessageConfiguration?.onDetailsButtonPressed
                      ?.call(widget.message);
                },
                icon: const Icon(
                  Icons.info_outline,
                  size: 20,
                ),
              ),
            ),
          ),
        if (widget.message.reactions.isNotEmpty)
          ReactionWidget(
            reactions: widget.message.reactions,
            messageReactionConfig: widget.messageReactionConfig,
            isMessageBySender: widget.isMessageBySender,
          ),
      ],
    );
  }

  Widget _buildQuestionHeader(QuizMessageConfiguration? config) {
    return Row(
      children: [
        Icon(
          Icons.quiz,
          size: 20,
          color: config?.quizIconColor ?? Colors.orange[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _quizMessage!.question,
            style: config?.questionTextStyle ??
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

  Widget _buildQuizOptions(QuizMessageConfiguration? config) {
    return Column(
      children: _quizMessage!.options.map((option) {
        final isSelected = _selectedOptionId == option.id;
        final isCorrect = option.isCorrect;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _isAnswered
              ? _buildResultOption(option, isSelected, isCorrect, config)
              : _buildQuizOption(option, isSelected, config),
        );
      }).toList(),
    );
  }

  Widget _buildAnswersCount(QuizMessageConfiguration? config) {
    int answeredCount = 0;
    List<String> answeredBy = [];
    for (QuizOption option in _quizMessage!.options) {
      if (option.voters.isNotEmpty) {
        answeredCount += option.voters.length;
      }
    }

    for (QuizOption option in _quizMessage!.options) {
      if (option.voters.isNotEmpty) {
        answeredBy.addAll(option.voters);
      }
    }

    return Row(
      children: [
        HorizontalUserAvatars(
          users: ChatViewInheritedWidget.of(context)
                  ?.chatController
                  .getUsersByIds(answeredBy) ??
              [],
          maxVisibleUsers: 6,
          circleRadius: 8,
        ),
        const SizedBox(width: 8),
        Text(
          '$answeredCount answer${answeredCount == 1 ? '' : 's'}',
          style: config?.questionCountTextStyle ??
              const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
        ),
      ],
    );
  }

  Widget _buildQuizOption(
      QuizOption option, bool isSelected, QuizMessageConfiguration? config) {
    return GestureDetector(
      onTap: () => _onOptionSelected(option.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: config?.optionPadding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? config?.selectedOptionBackgroundColor ?? Colors.orange[50]
              : config?.unselectedOptionBackgroundColor ?? Colors.white,
          borderRadius: config?.optionBorderRadius ?? BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? config?.selectedOptionBorderColor ?? Colors.orange
                : config?.unselectedOptionBorderColor ?? Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? config?.selectedRadioColor ?? Colors.orange
                  : config?.unselectedRadioColor ?? Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                option.text,
                style: isSelected
                    ? config?.selectedOptionTextStyle ??
                        TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[700],
                        )
                    : config?.optionTextStyle ??
                        const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultOption(QuizOption option, bool isSelected, bool isCorrect,
      QuizMessageConfiguration? config) {
    return Container(
      padding: config?.optionPadding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isCorrect
            ? config?.correctOptionBackgroundColor ?? Colors.green[50]
            : isSelected
                ? config?.incorrectOptionBackgroundColor ?? Colors.red[50]
                : config?.unselectedOptionBackgroundColor ?? Colors.white,
        borderRadius: config?.optionBorderRadius ?? BorderRadius.circular(8),
        border: Border.all(
          color: isCorrect
              ? config?.correctOptionBorderColor ?? Colors.green
              : isSelected
                  ? config?.incorrectOptionBorderColor ?? Colors.red
                  : config?.unselectedOptionBorderColor ?? Colors.grey[300]!,
          width: (isCorrect || isSelected) ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect
                ? Icons.check_circle
                : isSelected
                    ? Icons.cancel
                    : Icons.radio_button_unchecked,
            color: isCorrect
                ? config?.correctCheckIconColor ?? Colors.green
                : isSelected
                    ? config?.incorrectXIconColor ?? Colors.red
                    : config?.unselectedRadioColor ?? Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              option.text,
              style: isCorrect
                  ? config?.correctOptionTextStyle ??
                      const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      )
                  : isSelected
                      ? config?.incorrectOptionTextStyle ??
                          const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          )
                      : config?.optionTextStyle ??
                          const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanation(QuizMessageConfiguration? config) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: config?.explanationBackgroundColor ?? Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: config?.explanationBackgroundColor?.withValues(alpha: 0.3) ??
              Colors.blue[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb,
                size: 16,
                color: Colors.blue[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Explanation',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _quizMessage!.explanation!,
            style: config?.explanationTextStyle ??
                const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
          ),
        ],
      ),
    );
  }

  void _onOptionSelected(String optionId) {
    if (!_isAnswered) {
      setState(() {
        _selectedOptionId = optionId;
        _isAnswered = true;
      });

      // Find if the selected option is correct
      final selectedOption = _quizMessage?.options.firstWhere(
        (option) => option.id == optionId,
        orElse: () => const QuizOption(id: '', text: '', isCorrect: false),
      );
      final isCorrect = selectedOption?.isCorrect ?? false;

      // Call the configuration callback if available
      widget.quizMessageConfiguration?.onAnswerSubmitted
          ?.call(widget.message.id, optionId, isCorrect);

      // Call the legacy callback if available
      widget.onAnswerSubmitted?.call(widget.message.id, optionId, isCorrect);

      // Call quiz completed callback if available
      widget.quizMessageConfiguration?.onQuizCompleted?.call();
    }
  }
}
