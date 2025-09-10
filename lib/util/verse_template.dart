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
    return Center(
      child: SizedBox(
        width: 350, // Fixed width
        child: GestureDetector(
          onDoubleTap: onLike,
          child: Card.filled(
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        onPressed: onLike,
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                        ),
                      ),
                      IconButton(onPressed: onShare, icon: Icon(Icons.share)),
                    ],
                  ),
                  Text(
                    reference,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                  ),
                  const SizedBox(
                    height: 10,
                  ), // Spacing between title and subtitle
                  // Subtitle
                  Text(
                    verse,
                    style: TextStyle(fontFamily: 'Lora', fontSize: 20),
                    //textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ), // Spacing between content and actions
                  // Action buttons
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
