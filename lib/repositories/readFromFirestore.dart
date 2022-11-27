import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import '../model/songModel.dart';

Future<playListModle> readPlayListFromStore(String name) async {
  playListModle play = new playListModle(name: name, listSong: []);
  final Future<playListModle> playFu;
  final db = FirebaseFirestore.instance;
  final docRef = db. collection("playlist").doc(name);
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
  print(list);
  await Future.forEach(map.entries, (MapEntry m) async {
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
  SongModel song;
  final db = FirebaseFirestore.instance;
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
      name: map['name']);
}
