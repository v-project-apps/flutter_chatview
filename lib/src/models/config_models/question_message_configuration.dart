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

/// Configuration for question message appearance and behavior
class QuestionMessageConfiguration {
  /// Background color for the question message container
  final Color? backgroundColor;

  /// Border radius for the question message container
  final BorderRadius? borderRadius;

  /// Padding for the question message container
  final EdgeInsets? padding;

  /// Style for the prompt text
  final TextStyle? promptTextStyle;

  /// Style for the user question text
  final TextStyle? userQuestionTextStyle;

  /// Style for the submit button text
  final TextStyle? submitButtonTextStyle;

  /// Style for the submitted time text
  final TextStyle? submittedTimeTextStyle;

  /// Color for the question icon
  final Color? questionIconColor;

  /// Color for the text field background
  final Color? textFieldBackgroundColor;

  /// Color for the text field border
  final Color? textFieldBorderColor;

  /// Color for the text field focused border
  final Color? textFieldFocusedBorderColor;

  /// Color for the submit button background
  final Color? submitButtonBackgroundColor;

  /// Color for the submit button disabled background
  final Color? submitButtonDisabledBackgroundColor;

  /// Color for the submit button text
  final Color? submitButtonTextColor;

  /// Color for the submit button disabled text
  final Color? submitButtonDisabledTextColor;

  /// Border radius for the text field
  final BorderRadius? textFieldBorderRadius;

  /// Border radius for the submit button
  final BorderRadius? submitButtonBorderRadius;

  /// Padding for the text field
  final EdgeInsets? textFieldPadding;

  /// Padding for the submit button
  final EdgeInsets? submitButtonPadding;

  /// Hint text for the text field
  final String? textFieldHintText;

  /// Maximum lines for the text field
  final int? textFieldMaxLines;

  /// Style for the question count text
  final TextStyle? questionCountTextStyle;

  /// Callback when a question is submitted
  final Function(String messageId, QuestionSubmission submission)?
      onQuestionSubmitted;

  /// Callback when question submission is cancelled
  final VoidCallback? onQuestionCancelled;

  /// Custom builder for the question message
  final Widget Function(Message message)? questionMessageBuilder;

  const QuestionMessageConfiguration({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.promptTextStyle,
    this.userQuestionTextStyle,
    this.submitButtonTextStyle,
    this.submittedTimeTextStyle,
    this.questionIconColor,
    this.textFieldBackgroundColor,
    this.textFieldBorderColor,
    this.textFieldFocusedBorderColor,
    this.submitButtonBackgroundColor,
    this.submitButtonDisabledBackgroundColor,
    this.submitButtonTextColor,
    this.submitButtonDisabledTextColor,
    this.textFieldBorderRadius,
    this.submitButtonBorderRadius,
    this.textFieldPadding,
    this.submitButtonPadding,
    this.textFieldHintText,
    this.textFieldMaxLines,
    this.onQuestionSubmitted,
    this.onQuestionCancelled,
    this.questionMessageBuilder,
    this.questionCountTextStyle,
  });
}
