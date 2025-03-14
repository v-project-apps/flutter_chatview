class Reaction {
  Reaction({
    required this.reactions,
    required this.reactedUserIds,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    final reactionsList = json['reactions'] is List<dynamic>
        ? json['reactions'] as List<dynamic>
        : <dynamic>[];

    final reactions = <String>[
      for (var i = 0; i < reactionsList.length; i++)
        if (reactionsList[i]?.toString().isNotEmpty ?? false)
          reactionsList[i]!.toString()
    ];

    final reactedUserIdList = json['reacted_user_ids'] is List<dynamic>
        ? json['reacted_user_ids'] as List<dynamic>
        : <dynamic>[];

    final reactedUserIds = <String>[
      for (var i = 0; i < reactedUserIdList.length; i++)
        if (reactedUserIdList[i]?.toString().isNotEmpty ?? false)
          reactedUserIdList[i]!.toString()
    ];

    return Reaction(
      reactions: reactions,
      reactedUserIds: reactedUserIds,
    );
  }

  /// Provides list of reaction in single message.
  final List<String> reactions;

  Map<String, int> get reactionsWithCountMap => {
        for (var reaction in reactions)
          reaction: reactions.where((element) => element == reaction).length
      };

  /// Provides list of user who reacted on message.
  final List<String> reactedUserIds;

  Map<String, dynamic> toJson() => {
        'reactions': reactions,
        'reacted_user_ids': reactedUserIds,
      };

  Reaction copyWith({
    List<String>? reactions,
    List<String>? reactedUserIds,
  }) {
    return Reaction(
      reactions: reactions ?? this.reactions,
      reactedUserIds: reactedUserIds ?? this.reactedUserIds,
    );
  }
}
