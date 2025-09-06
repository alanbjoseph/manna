import 'package:flutter/material.dart';

class VerseTemplate extends StatelessWidget {
  final String reference;
  final String verse;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onShare;

  VerseTemplate({
    required this.reference,
    required this.verse,
    required this.isLiked,
    required this.onLike,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                reference,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

              //SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(verse, style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),

        // buttons
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: onLike,
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                    ),
                  ),
                  IconButton(onPressed: onShare, icon: Icon(Icons.share)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
