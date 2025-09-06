import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    final Box favoritesBox = Hive.box('favoritesBox');

    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) {
        if (didpop) {
          return;
        } else {
          Navigator.pushReplacementNamed(context, '/');
          //return false;
        }
      }),
      child: Scaffold(
        appBar: AppBar(title: Text('Favorites')),
        body: ValueListenableBuilder(
          valueListenable: favoritesBox.listenable(),
          builder: (context, Box box, _) {
            if (box.isEmpty) {
              return Center(child: Text('No favorites yet.'));
            }
      
            return ListView.separated(
              itemCount: box.length,
              itemBuilder: (context, index) {
                final key = box.keyAt(index);
                final verse = box.getAt(index);
      
                if (verse == null || verse is! Map) {
                  return SizedBox.shrink();
                }
      
                return ListTile(
                  title: Text(verse["reference"] ?? 'No reference'),
                  subtitle: Text(verse["text"] ?? 'No text'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      // Confirm before unfavoriting
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Remove Favorite'),
                          content: Text(
                            'Do you want to remove this verse from favorites?',
                          ),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                              child: Text(
                                'Remove',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                favoritesBox.delete(key); // Remove from Hive
                                Navigator.pop(context); // Close dialog
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
            );
          },
        ),
      ),
    );
  }
}
