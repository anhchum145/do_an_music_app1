import 'dart:io';

import 'package:do_an_music_app1/main.dart';
import 'package:do_an_music_app1/model/getPlayList.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/model/songModel.dart';
import 'package:do_an_music_app1/repositories/music_repository.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:id3/id3.dart';
import 'package:path_provider/path_provider.dart';

download(SongModel song) async {
  final appDocDir = await getExternalStorageDirectory();
  final filePathMp3 = "${appDocDir?.path}/Music";
  if (!await Directory(filePathMp3).exists()) {
    await Directory(filePathMp3).create();
  }
  final r = await FlutterDownloader.enqueue(
    fileName: "${song.name}.mp3",
    url: song.linkSong.toString(),

    savedDir: filePathMp3,
    showNotification:
        true, // show download progress in status bar (for Android)
    openFileFromNotification:
        true, // click on notification to open downloaded file (for Android)
    saveInPublicStorage: false,
    requiresStorageNotLow: true,
  );
}

Future<playListModle> getPlaylistDowloaded() async {
  var listPath = await getPlayListLocal();
  playListModle play = new playListModle(
      name: 'Local', listSong: [], id: '', pic: '', mode: true);
  int i = 0;
  for (String path in listPath) {
    var meta = readMata(path);
    SongModel song = SongModel(
        id: i.toString(),
        linkSong: '',
        path: path,
        artist: meta!['Artist'],
        name: meta['Title'],
        coverlink: '');
    play.listSong.add(song);
    i++;
  }
  return play;
}

Future<void> deleteFile(File file) async {
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    // Error in getting access to the file.
  }
}
