import 'flash_card.dart';

class CardStack {
  final String name;
  final List<FlashCard> cards;
  final int sortOrder;
  final String? emoji;

  const CardStack({
    required this.name,
    required this.cards,
    required this.sortOrder,
    this.emoji,
  });

  factory CardStack.fromJson(Map<String, dynamic> json) => CardStack(
      name: json['name'],
      sortOrder: json['sort_order'] ?? 0,
      cards: (json['cards'] as List)
          .map((i) => FlashCard.fromJson(Map<String, dynamic>.from(i)))
          .toList(),
      emoji: json['emoji']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'sort_order': sortOrder,
        'cards': cards.map((i) => i.toJson()).toList(),
        if (emoji != null) 'emoji': emoji,
      };
}
