import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

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
                      final deletedVerse = favoritesBox.get(key);

                      favoritesBox.delete(key);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Removed from favorites"),
                          action: SnackBarAction(
                            label: "Undo",
                            onPressed: () {
                              favoritesBox.put(key, deletedVerse);
                            },
                          ),
                          duration: Duration(seconds: 3),
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
