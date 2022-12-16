import 'package:do_an_music_app1/main.dart';
import 'package:do_an_music_app1/repositories/StreamAlbum.dart';
import 'package:do_an_music_app1/repositories/service.dart';
import 'package:do_an_music_app1/views/appbar.dart';
import 'package:do_an_music_app1/views/menu.dart';
import 'package:flutter/material.dart';

// class AlbumScreen extends StatelessWidget {
//   AlbumScreen(this.list, this.context1, {super.key});
//   List<Map<String, String>> list;
//   BuildContext context1;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: appBar("Album"),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           menu(context1),
//         ],
//       ),
//     );
//   }
// }

List<Card> _buildGridCards(int count, List<Map<String, String>> list,
    BuildContext context1, MyStream stream) {
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
              const SizedBox(
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
                            : const CircularProgressIndicator(strokeWidth: 1.0),
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset("assets/cover.png"),
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
            stream.increment(list[index]["id"].toString());
          },
        ),
      );
    },
  );
  return cards;
}

Widget AlbumWidget(
    List<Map<String, String>> list, BuildContext context1, MyStream stream) {
  return GridView.count(
    scrollDirection: Axis.vertical,
    crossAxisCount: 2,
    padding: const EdgeInsets.all(16.0),
    childAspectRatio: 8.0 / 9.0,
    shrinkWrap: true,
    // TODO: Build a grid of cards (102)
    children: _buildGridCards(list.length, list, context1, stream),
  );
}

String s = '';
setAlbum(String album) {
  s = album;
}

String getAlbum() {
  return s;
}
