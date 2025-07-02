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

import 'package:flutter/foundation.dart';

/// Represents a quiz option in a quiz message
class QuizOption {
  final String id;
  final String text;
  final bool isCorrect;
  final List<String> voters;

  const QuizOption({
    required this.id,
    required this.text,
    required this.isCorrect,
    this.voters = const [],
  });

  QuizOption copyWith({
    String? id,
    String? text,
    bool? isCorrect,
    List<String>? voters,
  }) {
    return QuizOption(
      id: id ?? this.id,
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
      voters: voters ?? this.voters,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isCorrect': isCorrect,
        'voters': voters,
      };

  factory QuizOption.fromJson(Map<String, dynamic> json) => QuizOption(
        id: json['id']?.toString() ?? '',
        text: json['text']?.toString() ?? '',
        isCorrect: json['isCorrect'] ?? false,
        voters: json['voters'] is List<dynamic>
            ? List<String>.from(json['voters'].map((v) => v.toString()))
            : [],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizOption &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          isCorrect == other.isCorrect &&
          listEquals(voters, other.voters);

  @override
  int get hashCode =>
      id.hashCode ^ text.hashCode ^ isCorrect.hashCode ^ voters.hashCode;
}

/// Represents a quiz message with question, options, and answer state
class QuizMessage {
  final String question;
  final List<QuizOption> options;
  final String? explanation;

  const QuizMessage({
    required this.question,
    required this.options,
    this.explanation,
  });

  QuizMessage copyWith({
    String? question,
    List<QuizOption>? options,
    String? selectedOptionId,
    bool? isAnswered,
    String? explanation,
  }) {
    return QuizMessage(
      question: question ?? this.question,
      options: options ?? this.options,
      explanation: explanation ?? this.explanation,
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'options': options.map((option) => option.toJson()).toList(),
        'explanation': explanation,
      };

  factory QuizMessage.fromJson(Map<String, dynamic> json) => QuizMessage(
        question: json['question']?.toString() ?? '',
        options: json['options'] is List<dynamic>
            ? List<QuizOption>.from(
                json['options'].map((option) => QuizOption.fromJson(option)))
            : [],
        explanation: json['explanation']?.toString(),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizMessage &&
          runtimeType == other.runtimeType &&
          question == other.question &&
          listEquals(options, other.options) &&
          explanation == other.explanation;

  @override
  int get hashCode =>
      question.hashCode ^ options.hashCode ^ explanation.hashCode;
}
