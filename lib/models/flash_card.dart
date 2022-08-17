class FlashCard {
  final String front;
  final String back;
  final bool selected;
  final int id;

  const FlashCard({
    required this.id,
    required this.front,
    required this.back,
    required this.selected,
  });

  factory FlashCard.fromJson(Map<String, dynamic> json) => FlashCard(
        front: json['front'],
        back: json['back'],
        selected: json['selected'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'front': front,
        'back': back,
        'selected': selected,
        'id': id,
      };
}
