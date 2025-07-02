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

/// Represents an ask-a-question message with prompt and user's question
class QuestionMessage {
  final String prompt;
  final List<QuestionSubmission> submissions;

  const QuestionMessage({
    required this.prompt,
    this.submissions = const [],
  });

  QuestionMessage copyWith({
    String? prompt,
    List<QuestionSubmission>? submissions,
  }) {
    return QuestionMessage(
      prompt: prompt ?? this.prompt,
      submissions: submissions ?? this.submissions,
    );
  }

  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'submissions': submissions.map((e) => e.toJson()).toList(),
      };

  factory QuestionMessage.fromJson(Map<String, dynamic> json) =>
      QuestionMessage(
        prompt: json['prompt']?.toString() ?? '',
        submissions: (json['submissions'] as List<dynamic>?)
                ?.map((e) =>
                    QuestionSubmission.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionMessage &&
          runtimeType == other.runtimeType &&
          prompt == other.prompt &&
          listEquals(submissions, other.submissions);

  @override
  int get hashCode => prompt.hashCode ^ submissions.hashCode;
}

class QuestionSubmission {
  final String userId;
  final DateTime? submittedAt;
  final String userQuestion;

  QuestionSubmission({
    required this.userId,
    this.submittedAt,
    required this.userQuestion,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'submittedAt': submittedAt?.toIso8601String(),
        'userQuestion': userQuestion,
      };

  factory QuestionSubmission.fromJson(Map<String, dynamic> json) =>
      QuestionSubmission(
        userId: json['userId']?.toString() ?? '',
        submittedAt: json['submittedAt'] != null
            ? DateTime.parse(json['submittedAt'])
            : null,
        userQuestion: json['userQuestion']?.toString() ?? '',
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionSubmission &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          submittedAt == other.submittedAt &&
          userQuestion == other.userQuestion;

  @override
  int get hashCode =>
      userId.hashCode ^ submittedAt.hashCode ^ userQuestion.hashCode;
}
