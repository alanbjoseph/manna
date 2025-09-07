import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

Future<void> seedVerses(Box versesBox) async {
  if (versesBox.isEmpty) {
    final String jsonString =
        await rootBundle.loadString('assets/dataset/verses_dataset.json');

    final List<dynamic> jsonData = json.decode(jsonString);

    for (var verse in jsonData) {
      await versesBox.add({
        "reference": verse["reference"],
        "text": verse["text"],
        "tags": List<String>.from(verse["tags"]),
      });
    }

    print("Seeded ${jsonData.length} verses into Hive.");
  } else {
    print("Verses already exist in Hive, skipping seeding.");
  }
}
