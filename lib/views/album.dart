import 'package:do_an_music_app1/main.dart';
import 'package:flutter/material.dart';

class AlbumScreen extends StatelessWidget {
  AlbumScreen(this.list, {super.key});
  List<Map<String, String>> list;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16.0),
      childAspectRatio: 8.0 / 9.0,
      // TODO: Build a grid of cards (102)
      children: _buildGridCards(list.length, list),
    );
  }
}

List<Card> _buildGridCards(int count, List<Map<String, String>> list) {
  List<Card> cards = List.generate(
    count,
    (int index) {
      String name = list[index]["name"].toString();

      return Card(
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              AspectRatio(
                aspectRatio: 30.0 / 20.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    list[index]["pic"].toString(),
                    width: 70,
                    loadingBuilder: (context, child, loadingProgress) =>
                        (loadingProgress == null)
                            ? child
                            : CircularProgressIndicator(strokeWidth: 1.0),
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset("assets/cover.jpg"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name),
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
            // main();
          },
        ),
      );
    },
  );
  return cards;
}
