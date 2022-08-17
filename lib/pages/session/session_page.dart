import 'package:flutter/material.dart';

import 'package:simple_flashcards/models/flash_card.dart';
import 'package:simple_flashcards/pages/session/session_page_view.dart';

class SessionPage extends StatefulWidget {
  final List<FlashCard> flashCards;
  const SessionPage(this.flashCards, {Key? key}) : super(key: key);

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

  void cardKnown() => setState(() {
        cards.removeAt(0);
        flipped = false;
      });

  void cardNotKnown() => setState(() {
        notKnownCards.add(cards.removeAt(0));
        flipped = false;
      });

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
