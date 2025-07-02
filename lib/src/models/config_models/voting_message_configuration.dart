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

import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';

/// Configuration for voting message appearance and behavior
class VotingMessageConfiguration {
  /// Background color for the voting message container
  final Color? backgroundColor;

  /// Border radius for the voting message container
  final BorderRadius? borderRadius;

  /// Padding for the voting message container
  final EdgeInsets? padding;

  /// Style for the question text
  final TextStyle? questionTextStyle;

  /// Style for option text
  final TextStyle? optionTextStyle;

  /// Style for selected option text
  final TextStyle? selectedOptionTextStyle;

  /// Style for percentage text
  final TextStyle? percentageTextStyle;

  /// Style for voter count text
  final TextStyle? voterCountTextStyle;

  /// Color for the poll icon
  final Color? pollIconColor;

  /// Color for unselected option background
  final Color? unselectedOptionBackgroundColor;

  /// Color for selected option background
  final Color? selectedOptionBackgroundColor;

  /// Color for unselected option border
  final Color? unselectedOptionBorderColor;

  /// Color for selected option border
  final Color? selectedOptionBorderColor;

  /// Color for unselected radio button
  final Color? unselectedRadioColor;

  /// Color for selected radio button
  final Color? selectedRadioColor;

  /// Color for check icon in results
  final Color? checkIconColor;

  /// Color for progress bar background
  final Color? progressBarBackgroundColor;

  /// Color for progress bar fill
  final Color? progressBarFillColor;

  /// Border radius for voting options
  final BorderRadius? optionBorderRadius;

  /// Padding for voting options
  final EdgeInsets? optionPadding;

  /// Callback when a vote is submitted
  final Function(String messageId, String optionId)? onVoteSubmitted;

  /// Callback when voting is closed
  final VoidCallback? onVotingClosed;

  /// Custom builder for the voting message
  final Widget Function(Message message)? votingMessageBuilder;

  const VotingMessageConfiguration({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.questionTextStyle,
    this.optionTextStyle,
    this.selectedOptionTextStyle,
    this.percentageTextStyle,
    this.voterCountTextStyle,
    this.pollIconColor,
    this.unselectedOptionBackgroundColor,
    this.selectedOptionBackgroundColor,
    this.unselectedOptionBorderColor,
    this.selectedOptionBorderColor,
    this.unselectedRadioColor,
    this.selectedRadioColor,
    this.checkIconColor,
    this.progressBarBackgroundColor,
    this.progressBarFillColor,
    this.optionBorderRadius,
    this.optionPadding,
    this.onVoteSubmitted,
    this.onVotingClosed,
    this.votingMessageBuilder,
  });
}
