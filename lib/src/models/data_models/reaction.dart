class Reaction {
  Reaction({
    required this.name,
    required this.reactedUserId,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? "";
    final reactedUserId = json['reacted_user_id'] ?? "";

    return Reaction(
      name: name,
      reactedUserId: reactedUserId,
    );
  }

  /// Provides list of reaction in single message.
  final String name;

  /// Provides list of user who reacted on message.
  final String reactedUserId;

  Map<String, dynamic> toJson() => {
        'name': name,
        'reacted_user_id': reactedUserId,
      };

  Reaction copyWith({
    String? name,
    String? reactedUserId,
  }) {
    return Reaction(
      name: name ?? this.name,
      reactedUserId: reactedUserId ?? this.reactedUserId,
    );
  }
}

extension ReactionsExtension on List<Reaction> {
  Map<String, int> getReactionWithCountMap() {
    final Map<String, int> reactionMap = {};

    for (final reaction in this) {
      if (reactionMap.containsKey(reaction.name)) {
        reactionMap[reaction.name] = reactionMap[reaction.name]! + 1;
      } else {
        reactionMap[reaction.name] = 1;
      }
    }

    return Map.fromEntries(reactionMap.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value)));
  }
}
