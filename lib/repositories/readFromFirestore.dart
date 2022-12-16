import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import '../model/songModel.dart';

Future<playListModle> readPlayListFromStore(String id, bool isLove) async {
  playListModle play =
      playListModle(name: '', listSong: [], id: id, pic: "pic", mode: false);
  final db = FirebaseFirestore.instance;
  db.settings = const Settings(persistenceEnabled: true);

  final docRef = db.collection(isLove ? "user" : "playlist").doc(id);
  if (!isLove) {
    final docInfo = await docRef.collection("info").doc("info").get();
    final infodata = docInfo.data() as Map<String, dynamic>;

    var map = <String, dynamic>{};
    await docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        map = data;
      },
      onError: (e) => print("Error getting document: $e"),
    );
    final List<SongModel> l = [];
    play.name = infodata["name"];
    play.pic = infodata["pic"];
    await Future.forEach(map.entries, (MapEntry m) async {
      var b = !m.key.toString().contains("name");

      await readSongFromStore(m.value.toString())
          .then((value) => play.listSong.add(value));
    });
  } else {
    var map = <String, dynamic>{};
    await docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        map = data;
      },
      onError: (e) => print("Error getting document: $e"),
    );
    final List<SongModel> l = [];
    play.name = "Yêu thích";
    play.pic = "";
    await Future.forEach(map.entries, (MapEntry m) async {
      var b = !m.key.toString().contains("name");

      await readSongFromStore(m.value.toString())
          .then((value) => play.listSong.add(value));
    });
  }
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

Future<List<String>> readListLoveStore(String user) async {
  List<String> a = [];
  final db = FirebaseFirestore.instance;
  var nummers = await db.collection("user").doc(user).get().then(
    (DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      data.forEach(
        (key, value) {
          a.add(value);
        },
      );
    },
  );
  return a;
}
