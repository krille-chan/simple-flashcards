class FlashCard {
  final String front;
  final String back;
  final String? hint;
  final bool selected;
  final int id;
  final int level;
  final DateTime? lastLevelUp;

  const FlashCard({
    required this.id,
    required this.front,
    required this.back,
    required this.selected,
    required this.hint,
    this.level = 0,
    this.lastLevelUp,
  });

  factory FlashCard.fromJson(Map<String, dynamic> json) => FlashCard(
        front: json['front'],
        back: json['back'],
        hint: json['hint'],
        selected: json['selected'],
        id: json['id'],
        level: json['level'] ?? 0,
        lastLevelUp: json['last_level_up'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['last_level_up']),
      );

  Map<String, dynamic> toJson() => {
        'front': front,
        'back': back,
        'selected': selected,
        if (hint != null) 'hint': hint,
        'id': id,
        'level': level,
        if (lastLevelUp != null)
          'last_level_up': lastLevelUp?.millisecondsSinceEpoch
      };

  bool get canLevelUp {
    final lastLevelUp = this.lastLevelUp;
    if (lastLevelUp == null) return true;

    final waitingTime = Duration(hours: fibo(level));

    return DateTime.now().difference(lastLevelUp) > waitingTime;
  }
}

int fibo(int x) {
  if (x <= 2) return 1;
  return fibo(x - 2) + fibo(x - 1);
}
