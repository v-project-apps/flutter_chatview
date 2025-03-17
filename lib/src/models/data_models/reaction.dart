class Reaction {
  Reaction({
    required this.emoji,
    required this.reactedUserId,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    final name = json['emoji'] ?? "";
    final reactedUserId = json['reacted_user_id'] ?? "";

    return Reaction(
      emoji: name,
      reactedUserId: reactedUserId,
    );
  }

  /// Provides list of reaction in single message.
  final String emoji;

  /// Provides list of user who reacted on message.
  final String reactedUserId;

  Map<String, dynamic> toJson() => {
        'emoji': emoji,
        'reacted_user_id': reactedUserId,
      };

  Reaction copyWith({
    String? emoji,
    String? reactedUserId,
  }) {
    return Reaction(
      emoji: emoji ?? this.emoji,
      reactedUserId: reactedUserId ?? this.reactedUserId,
    );
  }
}

extension ReactionsExtension on List<Reaction> {
  Map<String, int> getReactionWithCountMap() {
    final Map<String, int> reactionMap = {};

    for (final reaction in this) {
      if (reactionMap.containsKey(reaction.emoji)) {
        reactionMap[reaction.emoji] = reactionMap[reaction.emoji]! + 1;
      } else {
        reactionMap[reaction.emoji] = 1;
      }
    }

    return Map.fromEntries(reactionMap.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value)));
  }
}
