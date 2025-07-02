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

/// Represents a voting option in a voting message
class VotingOption {
  final String id;
  final String text;
  final int votes;
  final List<String> voters;

  const VotingOption({
    required this.id,
    required this.text,
    this.votes = 0,
    this.voters = const [],
  });

  VotingOption copyWith({
    String? id,
    String? text,
    int? votes,
    List<String>? voters,
  }) {
    return VotingOption(
      id: id ?? this.id,
      text: text ?? this.text,
      votes: votes ?? this.votes,
      voters: voters ?? this.voters,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'votes': votes,
        'voters': voters,
      };

  factory VotingOption.fromJson(Map<String, dynamic> json) => VotingOption(
        id: json['id']?.toString() ?? '',
        text: json['text']?.toString() ?? '',
        votes: json['votes']?.toInt() ?? 0,
        voters: json['voters'] is List<dynamic>
            ? List<String>.from(json['voters'])
            : [],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VotingOption &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          votes == other.votes &&
          listEquals(voters, other.voters);

  @override
  int get hashCode =>
      id.hashCode ^ text.hashCode ^ votes.hashCode ^ voters.hashCode;
}

/// Represents a voting message with question, options, and voting state
class VotingMessage {
  final String question;
  final List<VotingOption> options;
  final bool isVotingClosed;
  final int totalVotes;
  final DateTime? votingEndTime;

  const VotingMessage({
    required this.question,
    required this.options,
    this.isVotingClosed = false,
    this.totalVotes = 0,
    this.votingEndTime,
  });

  VotingMessage copyWith({
    String? question,
    List<VotingOption>? options,
    bool? isVotingClosed,
    int? totalVotes,
    DateTime? votingEndTime,
  }) {
    return VotingMessage(
      question: question ?? this.question,
      options: options ?? this.options,
      isVotingClosed: isVotingClosed ?? this.isVotingClosed,
      totalVotes: totalVotes ?? this.totalVotes,
      votingEndTime: votingEndTime ?? this.votingEndTime,
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'options': options.map((option) => option.toJson()).toList(),
        'isVotingClosed': isVotingClosed,
        'totalVotes': totalVotes,
        'votingEndTime': votingEndTime?.toIso8601String(),
      };

  factory VotingMessage.fromJson(Map<String, dynamic> json) => VotingMessage(
        question: json['question']?.toString() ?? '',
        options: json['options'] is List<dynamic>
            ? List<VotingOption>.from(
                json['options'].map((option) => VotingOption.fromJson(option)))
            : [],
        isVotingClosed: json['isVotingClosed'] ?? false,
        totalVotes: json['totalVotes']?.toInt() ?? 0,
        votingEndTime: json['votingEndTime'] != null
            ? DateTime.parse(json['votingEndTime'])
            : null,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VotingMessage &&
          runtimeType == other.runtimeType &&
          question == other.question &&
          listEquals(options, other.options) &&
          isVotingClosed == other.isVotingClosed &&
          totalVotes == other.totalVotes &&
          votingEndTime == other.votingEndTime;

  @override
  int get hashCode =>
      question.hashCode ^
      options.hashCode ^
      isVotingClosed.hashCode ^
      totalVotes.hashCode ^
      votingEndTime.hashCode;
}
