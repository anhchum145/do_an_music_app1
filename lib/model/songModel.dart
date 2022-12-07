import 'dart:io';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:id3/id3.dart';

class SongModel {
  String id;
  String linkSong;
  String path;
  String name;
  String artist;
  String coverlink;

  SongModel(
      {required this.id,
      required this.linkSong,
      required this.path,
      required this.artist,
      required this.name,
      required this.coverlink});
  factory SongModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return SongModel(
        id: data?['id'],
        linkSong: data?['linkSong'],
        path: data?['path'],
        artist: data?['artist'],
        name: data?['name'],
        coverlink: data?['coverlink']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (linkSong != null) "linkSong": linkSong,
      if (path != null) "path": path,
      if (artist != null) "artist": artist,
      if (name != null) "name": name,
      if (coverlink != null) "coverlink": coverlink
    };
  }
}
