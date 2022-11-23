import 'package:do_an_music_app1/views/getPlaylist.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/getPlayList.dart';

getListSongFromFireBase() async {
  final storage = FirebaseStorage.instance.ref();
  final storageMusic = storage.child("music");
  final listResult = await storageMusic.listAll();
  String link = "";
  String path = "";
  List<String> listItem = [];
  for (var item in listResult.items) {
    link = await item.getDownloadURL();
    path = item.fullPath;
    listItem.add(link);
  }
  return listItem;
}

metaDataUp() async {
  List<String> path = getFullSong();
  int i = 0;
  final storage = FirebaseStorage.instance.ref();
  final storageMusic = storage.child("music");
  String name = "";
  final listResult = await storageMusic.listAll();

  for (var item in listResult.items) {
    for (var l in path) {
      if (l.contains(item.name)) {
        name = l;
        break;
      }
    }
    Map<String, dynamic>? b = readMata(name);

    final newCustomMetadata = SettableMetadata(
      customMetadata: {
        "Title": b!['Title'],
        "Artist": b['Artist'],
      },
    );
    final metadata = await item.updateMetadata(newCustomMetadata);

    i++;
  }
}

readMetaDataSong() {}
