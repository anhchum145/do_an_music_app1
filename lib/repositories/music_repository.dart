import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/model/songModel.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';

Future<playListModle> getPlayListFromFolder(String folder) async {
  final storage = FirebaseStorage.instance.ref();

  final List<SongModel> list = [];
  final playListModle playList = playListModle(
      name: folder, listSong: list, id: folder, pic: "pic", mode: true);
  final storageFolder = storage.child(folder);
  final listResult = await storageFolder.listAll();
  for (var item in listResult.items) {
    final meta = await item.getMetadata();
    String linkSong = await item.getDownloadURL();
    final now = DateTime.now();
    // final songMap = new Map();
    // songMap["id"] = now.microsecondsSinceEpoch.toString();
    // songMap["linkSong"] = linkSong;
    // songMap["path"] = item.fullPath;
    // songMap["artist"] = meta.customMetadata!["Artist"].toString();
    // songMap["title"] = meta.customMetadata!["Title"].toString();
    // final String song = jsonEncode(songMap);
    final SongModel song1 = SongModel(
      id: now.microsecondsSinceEpoch.toString(),
      linkSong: linkSong,
      path: item.fullPath,
      artist: meta.customMetadata!["Artist"].toString(),
      name: meta.customMetadata!["Title"].toString(),
      coverlink: " ",
    );
    list.add(song1);
  }
  playList.listSong = list;
  return playList;
}

bool getAPlayList(
    bool mode, playListModle play, AssetsAudioPlayer assetsAudioPlayer) {
  List<Audio> paths = [];

  for (SongModel s in play.listSong) {
    if (mode) {
      paths.add(Audio.file(s.path));
    } else {
      paths.add(Audio.network(s.linkSong));
    }
  }
  assetsAudioPlayer.open(
    Playlist(audios: paths),
    autoStart: false,
    showNotification: true,
    loopMode: LoopMode.playlist,
    playInBackground: PlayInBackground.enabled,
    forceOpen: true,
  );

  return paths.isNotEmpty ? true : false;
}
