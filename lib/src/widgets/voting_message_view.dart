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

class VotingMessageView extends StatefulWidget {
  const VotingMessageView({
    Key? key,
    required this.message,
    required this.isMessageBySender,
    required this.inComingChatBubbleConfig,
    required this.outgoingChatBubbleConfig,
    this.chatBubbleMaxWidth,
    this.messageReactionConfig,
    this.votingMessageConfiguration,
    this.onVoteSubmitted,
  }) : super(key: key);

  final Message message;
  final bool isMessageBySender;
  final ChatBubble? inComingChatBubbleConfig;
  final ChatBubble? outgoingChatBubbleConfig;
  final double? chatBubbleMaxWidth;
  final MessageReactionConfiguration? messageReactionConfig;
  final VotingMessageConfiguration? votingMessageConfiguration;
  final Function(String optionId)? onVoteSubmitted;

  @override
  State<VotingMessageView> createState() => _VotingMessageViewState();
}

class _VotingMessageViewState extends State<VotingMessageView> {
  VotingMessage? _votingMessage;
  bool _isVoting = false;
  String? _selectedOptionId;

  void _parseVotingMessage() {
    try {
      // Parse voting data from message field as JSON string
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(jsonDecode(widget.message.message));

      // Try to parse as VotingMessage directly (without type field)
      _votingMessage = VotingMessage.fromJson(data);
      if (_selectedOptionId == null) {
        String? currentUserId = chatViewIW?.chatController.currentUser.id;
        for (VotingOption option in _votingMessage?.options ?? []) {
          if (option.voters.contains(currentUserId)) {
            _selectedOptionId = option.id;
            break;
          }
        }
      }
      _isVoting = _selectedOptionId == null &&
          !(_votingMessage?.isVotingClosed ?? false);
    } catch (e) {
      // Handle parsing error
      debugPrint('Error parsing voting message: $e');
    }
  }

  @override
  void didChangeDependencies() {
    _parseVotingMessage();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant VotingMessageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _parseVotingMessage();
  }

  @override
  Widget build(BuildContext context) {
    if (_votingMessage == null) {
      return const SizedBox.shrink();
    }

    final config = widget.votingMessageConfiguration;
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
                _buildVotingOptions(config),
                const SizedBox(height: 8),
                _buildVoterCount(config),
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
                includeCurrentUser: true,
                circleRadius: 8,
              ),
            ),
          ),
        if (config?.showDetailsButton ?? false)
          Positioned(
            top: 0,
            right: widget.isMessageBySender ? null : 0,
            left: widget.isMessageBySender ? 0 : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: IconButton(
                onPressed: () {
                  widget.votingMessageConfiguration?.onDetailsButtonPressed
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

  Widget _buildQuestionHeader(VotingMessageConfiguration? config) {
    return Row(
      children: [
        Icon(
          Icons.poll,
          size: 20,
          color: config?.pollIconColor ?? Colors.blue[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _votingMessage!.question,
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

  Widget _buildVotingOptions(VotingMessageConfiguration? config) {
    return Column(
      children: _votingMessage!.options.map((option) {
        final isSelected = _selectedOptionId == option.id;
        final isVotingClosed = _votingMessage!.isVotingClosed;
        final totalVotes = _votingMessage!.totalVotes;
        final percentage = totalVotes > 0 ? (option.votes / totalVotes) : 0.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _isVoting && !isVotingClosed
              ? _buildVotingOption(option, isSelected, config)
              : _buildResultOption(option, isSelected, percentage, config),
        );
      }).toList(),
    );
  }

  Widget _buildVotingOption(VotingOption option, bool isSelected,
      VotingMessageConfiguration? config) {
    return GestureDetector(
      onTap: () => _onOptionSelected(option.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: config?.optionPadding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? config?.selectedOptionBackgroundColor ?? Colors.blue[50]
              : config?.unselectedOptionBackgroundColor ?? Colors.white,
          borderRadius: config?.optionBorderRadius ?? BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? config?.selectedOptionBorderColor ?? Colors.blue
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
                  ? config?.selectedRadioColor ?? Colors.blue
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
                          color: Colors.blue[700],
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

  Widget _buildResultOption(VotingOption option, bool isSelected,
      double percentage, VotingMessageConfiguration? config) {
    return Container(
      padding: config?.optionPadding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? config?.selectedOptionBackgroundColor ?? Colors.blue[50]
            : config?.unselectedOptionBackgroundColor ?? Colors.white,
        borderRadius: config?.optionBorderRadius ?? BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? config?.selectedOptionBorderColor ?? Colors.blue
              : config?.unselectedOptionBorderColor ?? Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected
                    ? config?.checkIconColor ?? Colors.blue
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
                            color: Colors.blue[700],
                          )
                      : config?.optionTextStyle ??
                          const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                ),
              ),
              HorizontalUserAvatars(
                users: ChatViewInheritedWidget.of(context)
                        ?.chatController
                        .getUsersByIds(option.voters) ??
                    [],
                circleRadius: 8,
              ),
              const SizedBox(width: 8),
              Text(
                '${(percentage * 100).toInt()}%',
                style: config?.percentageTextStyle ??
                    TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.blue[700] : Colors.grey[600],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: config?.progressBarBackgroundColor ?? Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                height: 4,
                width: MediaQuery.of(context).size.width * 0.6 * percentage,
                decoration: BoxDecoration(
                  color: config?.progressBarFillColor ?? Colors.blue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoterCount(VotingMessageConfiguration? config) {
    return Text(
      '${_votingMessage!.totalVotes} vote${_votingMessage!.totalVotes == 1 ? '' : 's'}',
      style: config?.voterCountTextStyle ??
          const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
    );
  }

  void _onOptionSelected(String optionId) {
    if (_isVoting && !(_votingMessage?.isVotingClosed ?? false)) {
      setState(() {
        _selectedOptionId = optionId;
        _isVoting = false;
      });

      // Call the configuration callback if available
      widget.votingMessageConfiguration?.onVoteSubmitted
          ?.call(widget.message.id, optionId);

      // Call the legacy callback if available
      widget.onVoteSubmitted?.call(optionId);
    }
  }
}
