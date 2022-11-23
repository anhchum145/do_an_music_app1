import 'dart:convert';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:do_an_music_app1/Model/playListModle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_music_app1/Model/songModel.dart';

// Future<void> WriteDate(playListModle play) async {
//   final db = FirebaseFirestore.instance;

//   db.collection("playlistfull").add(play.toFirestore()).then(
//       (DocumentReference doc) =>
//           print('DocumentSnapshot added with ID: ${doc.id}'));
//   final docRef = db.collection("playlistfull").withConverter(
//         fromFirestore: playListModle.fromFirestore,
//         toFirestore: (playListModle play, options) => play.toFirestore(),
//       );
//   // await docRef.add(play);
//   // sleep(new Duration(seconds: 5));
//   // print("object");
//   // await db.add(play.toFirestore());
//   // final ref = db.collection("playlistfull").doc("E3w58hxFYnh7NWBkJIF3");

//   // final play = await ref.get();
//   // final p = play.data();
//   // String a = p!["listsong"][0];
//   await docRef.get();
//   // print(p);
//   // Map<String, dynamic> aa = jsonDecode(a) as Map<String, dynamic>;
//   // SongModel s = new SongModel(
//   //     aa["id"], aa["linkSong"], aa["path"], aa["artist"], aa["title"]);

//   print("aa");
// }

// Future<playListModle> ReadPlayList() async {
//   playListModle playlist;
//   final db = FirebaseFirestore.instance;

//   final ref =
//       db.collection("playlistfull").doc("E3w58hxFYnh7NWBkJIF3").withConverter(
//             fromFirestore: playListModle.fromFirestore,
//             toFirestore: (playListModle playlist, _) => playlist.toFirestore(),
//           );
//   final docSnap = await ref.get();
//   final play = docSnap.data(); // Convert to City object
//   if (play != null) {
//     print(play);
//   } else {
//     print("No such document.");
//   }
//   playlist = play!;

//   return playlist;
// }

// playListModle GetPlayList()  {
//   final db = FirebaseFirestore.instance;
//   final docRef = db.collection("playlistfull").doc("E3w58hxFYnh7NWBkJIF3");
//   docRef.get().then(
//     (DocumentSnapshot doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       // ...
//     },
//     onError: (e) => print("Error getting document: $e"),
//   );
// }
// Future<void> WriteSong(playListModle play) async{
//    final db = FirebaseFirestore.instance;
//    for(var song in play.listSong){

//    }

//   db.collection("song").add(play.toFirestore()).then(
//       (DocumentReference doc) =>
//           print('DocumentSnapshot added with ID: ${doc.id}'));
//   final docRef = db.collection("allsong").withConverter(
//         fromFirestore: SongModel.fromFirestore,
//         toFirestore: (playListModle play, options) => play.toFirestore(),
//       );
// }
Future<void> WriteSong(SongModel song) async {
  final db = FirebaseFirestore.instance;

  final docRef = db
      .collection("song")
      .withConverter(
        fromFirestore: SongModel.fromFirestore,
        toFirestore: (SongModel song, options) => song.toFirestore(),
      )
      .doc(song.id);
  await docRef.set(song);
}

Future<void> WritePlay() async {
  final db = FirebaseFirestore.instance;
  final a = new Map<String, String>();
  int i = 0;
  final song = await db.collection("song").get();
  song.docs.forEach(
    (element) => {
      a.addAll({i.toString(): element.id}),
      i++
    },
  );

  print("object");
  final docRef = db.collection("playlist").doc("full");
  await docRef.set(a);
}
