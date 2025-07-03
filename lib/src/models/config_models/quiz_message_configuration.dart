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

/// Configuration for quiz message appearance and behavior
class QuizMessageConfiguration {
  /// Background color for the quiz message container
  final Color? backgroundColor;

  /// Border radius for the quiz message container
  final BorderRadius? borderRadius;

  /// Padding for the quiz message container
  final EdgeInsets? padding;

  /// Style for the question text
  final TextStyle? questionTextStyle;

  /// Style for option text
  final TextStyle? optionTextStyle;

  /// Style for selected option text
  final TextStyle? selectedOptionTextStyle;

  /// Style for correct option text
  final TextStyle? correctOptionTextStyle;

  /// Style for incorrect option text
  final TextStyle? incorrectOptionTextStyle;

  /// Style for explanation text
  final TextStyle? explanationTextStyle;

  /// Style for score text
  final TextStyle? scoreTextStyle;

  /// Color for the quiz icon
  final Color? quizIconColor;

  /// Color for unselected option background
  final Color? unselectedOptionBackgroundColor;

  /// Color for selected option background
  final Color? selectedOptionBackgroundColor;

  /// Color for correct option background
  final Color? correctOptionBackgroundColor;

  /// Color for incorrect option background
  final Color? incorrectOptionBackgroundColor;

  /// Color for unselected option border
  final Color? unselectedOptionBorderColor;

  /// Color for selected option border
  final Color? selectedOptionBorderColor;

  /// Color for correct option border
  final Color? correctOptionBorderColor;

  /// Color for incorrect option border
  final Color? incorrectOptionBorderColor;

  /// Color for unselected radio button
  final Color? unselectedRadioColor;

  /// Color for selected radio button
  final Color? selectedRadioColor;

  /// Color for correct check icon
  final Color? correctCheckIconColor;

  /// Color for incorrect X icon
  final Color? incorrectXIconColor;

  /// Color for explanation background
  final Color? explanationBackgroundColor;

  /// Border radius for quiz options
  final BorderRadius? optionBorderRadius;

  /// Padding for quiz options
  final EdgeInsets? optionPadding;

  /// Callback when an answer is submitted
  final Function(String messageId, String optionId, bool isCorrect)?
      onAnswerSubmitted;

  /// Callback when quiz is completed
  final VoidCallback? onQuizCompleted;

  /// Custom builder for the quiz message
  final Widget Function(Message message)? quizMessageBuilder;

  /// Style for the question count text
  final TextStyle? questionCountTextStyle;

  const QuizMessageConfiguration({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.questionTextStyle,
    this.optionTextStyle,
    this.selectedOptionTextStyle,
    this.correctOptionTextStyle,
    this.incorrectOptionTextStyle,
    this.explanationTextStyle,
    this.scoreTextStyle,
    this.quizIconColor,
    this.unselectedOptionBackgroundColor,
    this.selectedOptionBackgroundColor,
    this.correctOptionBackgroundColor,
    this.incorrectOptionBackgroundColor,
    this.unselectedOptionBorderColor,
    this.selectedOptionBorderColor,
    this.correctOptionBorderColor,
    this.incorrectOptionBorderColor,
    this.unselectedRadioColor,
    this.selectedRadioColor,
    this.correctCheckIconColor,
    this.incorrectXIconColor,
    this.explanationBackgroundColor,
    this.optionBorderRadius,
    this.optionPadding,
    this.onAnswerSubmitted,
    this.onQuizCompleted,
    this.quizMessageBuilder,
    this.questionCountTextStyle,
  });
}
