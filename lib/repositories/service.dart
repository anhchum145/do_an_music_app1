import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/model/songModel.dart';
import 'package:do_an_music_app1/views/getPlaylist.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/getPlayList.dart';

Future<List<String>> getListSongFromFireBase() async {
  final storage = FirebaseStorage.instance.ref();
  final storageMusic = storage.child("music/ndv");
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

String idGenerator() {
  final now = DateTime.now();
  return now.microsecondsSinceEpoch.toString();
}

playListModle getPlayListModle() {
  playListModle play =
      new playListModle(name: "ndv", listSong: [], id: "ndv", pic: "");
  List<String> ds = getFullSong();
  List<String> link = [];
  getListSongFromFireBase().then((value) {
    for (int i = 0; i < ds.length; i++) {
      Map<String, dynamic>? m = readMata(ds[i]);
      SongModel s = new SongModel(
          id: idGenerator(),
          linkSong: link[i],
          path: "",
          artist: m!["Artist"],
          name: m["Title"],
          coverlink: m['coverlink']);
      play.listSong.add(s);
    }
  });

  return play;
}

metaDataUp() async {
  List<String> path = getFullSong();
  int i = 0;
  final storage = FirebaseStorage.instance.ref();
  final storageMusic = storage.child("/music/nhactrehot");
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

readListAlbum() async {
  final docr = await FirebaseFirestore.instance.collection("playlist").get();
  Map<String, String> a = new Map();
  List<Map<String, String>> l = [];
  for (var i in docr.docs) {
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("playlist").doc(i.id.toString());
    final docInfo = await docRef.collection("info").doc("info").get();
    final infodata = docInfo.data() as Map<String, dynamic>;
    a = new Map();
    a.addAll({"name": infodata["name"], "pic": infodata["pic"]});
    l.add(a);
  }

  return l;
}
