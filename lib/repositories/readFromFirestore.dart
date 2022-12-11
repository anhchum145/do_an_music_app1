import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import '../model/songModel.dart';

Future<playListModle> readPlayListFromStore(String id) async {
  playListModle play = new playListModle(
      name: '', listSong: [], id: id, pic: "pic", mode: false);
  final Future<playListModle> playFu;
  final db = FirebaseFirestore.instance;
<<<<<<< HEAD
  db.settings = const Settings(persistenceEnabled: true);

  final docRef = db.collection("playlist").doc(id);
  final docInfo = await docRef.collection("info").doc("info").get();
  final infodata = docInfo.data() as Map<String, dynamic>;
=======
  final docRef = db. collection("playlist").doc(name);
>>>>>>> b8fca1d46c5f8b9bea0edf0c14ebf9224d6bd813
  var map = new Map<String, dynamic>();
  await docRef.get().then(
    (DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      map = data;
    },
    onError: (e) => print("Error getting document: $e"),
  );
  final List<SongModel> l = [];
  String list = jsonEncode(map);
  play.name = infodata["name"];
  play.pic = infodata["pic"];
  print(list);
  await Future.forEach(map.entries, (MapEntry m) async {
    var b = !m.key.toString().contains("name");

    await readSongFromStore(m.value.toString())
        .then((value) => play.listSong.add(value));
  });
  // map.forEach(
  //   (key, value) async {},
  // );

  return play;
}

addv(playListModle play, v) {
  play.listSong.add(v);
}

Future<SongModel> readSongFromStore(String id) async {
  final db = FirebaseFirestore.instance;
  String a;
  final docRef = db.collection("song").doc(id);
  var map = new Map<String, dynamic>();
  await docRef.get().then(
    (DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      map = data;
    },
    onError: (e) => print("Error getting document: $e"),
  );
  return SongModel(
      id: map['id'],
      linkSong: map['linkSong'],
      path: map['path'],
      artist: map['artist'],
      name: map['name'],
      coverlink: map['coverlink']);
}
