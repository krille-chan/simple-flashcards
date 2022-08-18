import 'dart:math';

class FlashCard {
  final String front;
  final String back;
  final bool selected;
  final int id;
  final int level;
  final DateTime? lastLevelUp;

  const FlashCard({
    required this.id,
    required this.front,
    required this.back,
    required this.selected,
    this.level = 0,
    this.lastLevelUp,
  });

  factory FlashCard.fromJson(Map<String, dynamic> json) => FlashCard(
        front: json['front'],
        back: json['back'],
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
        'id': id,
        'level': level,
        if (lastLevelUp != null)
          'last_level_up': lastLevelUp?.millisecondsSinceEpoch
      };

  static const int levelUpWaitingHours = 2;

  bool get canLevelUp {
    final lastLevelUp = this.lastLevelUp;
    if (lastLevelUp == null) return true;

    final waitingTime =
        Duration(hours: pow(levelUpWaitingHours, level).round());

    return DateTime.now().difference(lastLevelUp) > waitingTime;
  }
}
