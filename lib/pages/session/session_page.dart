import 'package:flutter/material.dart';

import 'package:simple_flashcards/models/flash_card.dart';
import 'package:simple_flashcards/models/simple_flashcards.dart';
import 'package:simple_flashcards/pages/session/session_page_view.dart';

class SessionPage extends StatefulWidget {
  final String stackName;
  const SessionPage(this.stackName, {Key? key}) : super(key: key);

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
    final stack = SimpleFlashcards.of(context).getStack(widget.stackName);
    final initialCards = stack?.cards ?? [];
    initialCards.shuffle();
    cards.addAll(initialCards.take(maxCards));
  }

  void cardKnown() => setState(() {
        cards.removeAt(0);
        flipped = false;
      });

  void cardNotKnown() => setState(() {
        notKnownCards.add(cards.removeAt(0));
        flipped = false;
      });

  void repeatAllCards() {
    final stack = SimpleFlashcards.of(context).getStack(widget.stackName);
    setState(() {
      cards.addAll(stack?.cards ?? []);
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
