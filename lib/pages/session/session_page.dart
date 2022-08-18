import 'package:flutter/material.dart';

import 'package:simple_flashcards/models/flash_card.dart';
import 'package:simple_flashcards/models/simple_flashcards.dart';
import 'package:simple_flashcards/pages/session/session_page_view.dart';

class SessionPage extends StatefulWidget {
  final String stackName;
  final List<FlashCard> flashCards;
  const SessionPage({
    required this.flashCards,
    required this.stackName,
    Key? key,
  }) : super(key: key);

  @override
  SessionPageController createState() => SessionPageController();
}

class SessionPageController extends State<SessionPage> {
  final List<FlashCard> cards = [];
  final List<FlashCard> notKnownCards = [];

  bool flipped = false;

  void flip() => setState(() => flipped = !flipped);

  static const int maxCards = 10;

  @override
  void initState() {
    super.initState();
    cards.addAll(widget.flashCards);
  }

  void cardKnown() {
    final card = cards[0];
    if (card.canLevelUp && card.level < 10) {
      SimpleFlashcards.of(context).editCardLevel(
        widget.stackName,
        card.id,
        card.level + 1,
      );
    }
    setState(() {
      cards.removeAt(0);
      flipped = false;
    });
  }

  void cardNotKnown() {
    final card = cards[0];
    if (card.level > 0) {
      SimpleFlashcards.of(context).editCardLevel(
        widget.stackName,
        card.id,
        card.level - 1,
      );
    }
    setState(() {
      notKnownCards.add(cards.removeAt(0));
      flipped = false;
    });
  }

  void repeatAllCards() {
    setState(() {
      cards.addAll(widget.flashCards);
    });
  }

  void repeatNotKnownCards() {
    setState(() {
      cards.addAll(notKnownCards);
      notKnownCards.clear();
    });
  }

  @override
  Widget build(BuildContext context) => SessionPageView(this);
}
