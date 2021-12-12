class FlashCard {
  final String front;
  final String back;

  const FlashCard({
    required this.front,
    required this.back,
  });

  factory FlashCard.fromJson(Map<String, dynamic> json) => FlashCard(
        front: json['front'],
        back: json['back'],
      );

  Map<String, dynamic> toJson() => {
        'front': front,
        'back': back,
      };
}
