import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

import 'package:manna/util/verse_template.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  late List<dynamic> shuffledVerses;
  late final ValueListenable<Box> favoritesListenable;

  late Box versesBox;
  late Box favoritesBox;

  bool isFavorite(int index) {
    final verse = shuffledVerses[index];
    return favoritesBox.containsKey(verse['reference']);
  }

  @override
  void initState() {
    super.initState();
    versesBox = Hive.box('versesBox');
    shuffledVerses = versesBox.values.toList();
    shuffledVerses.shuffle();
    favoritesBox = Hive.box('favoritesBox');
    favoritesListenable = favoritesBox.listenable();
  }

  void onLike(int index) {
    final verse = shuffledVerses[index];
    final key = verse['reference'];

    if (favoritesBox.containsKey(key)) {
      favoritesBox.delete(key);
      print("Removed from favorites: $key");
    } else {
      favoritesBox.put(key, verse);
      print("Added to favorites: $key");
    }
  }

  void onShare(int index) {
    final verse = versesBox.getAt(index);
    // TODO: Use share_plus or clipboard
    print("Shared: ${verse['reference']}");
  }

  @override
  Widget build(BuildContext context) {
    if (versesBox.isEmpty) {
      return Scaffold(body: Center(child: Text("No verses available")));
    }

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: favoritesListenable,
        builder: (context, value, child) {
          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: shuffledVerses.length,
            itemBuilder: (context, index) {
              final verse = shuffledVerses[index];
              return VerseTemplate(
                reference: verse["reference"],
                verse: verse["text"],
                isLiked: isFavorite(index),
                onLike: () => onLike(index),
                onShare: () => onShare(index),
              );
            },
          );
        },
      ),
    );
  }
}
