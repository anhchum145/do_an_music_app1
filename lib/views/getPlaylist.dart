import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';

List<String> getFullSong() {
  Directory dir = Directory('/storage/151B-0F19/');
  String mp3Path = dir.toString();
  List<FileSystemEntity> _files;
  List<String> files = [];
  _files = dir.listSync(recursive: true, followLinks: true);
  for (FileSystemEntity entity in _files) {
    String path = entity.path;
    if (path.endsWith('.mp3')) {
      path = entity.toString().replaceAll("File: '", "");
      path = path.replaceAll("'", "");
      files.add(path);
    }
  }
  return files;
}

AssetsAudioPlayer getFullPlayList(List<FileSystemEntity> files) {
  AssetsAudioPlayer assetsAudioPlayer = new AssetsAudioPlayer();
  String path = "";
  List<String> _files = [];
  for (FileSystemEntity f in files) {
    path = f.toString().replaceAll("File: '", "");
    path = path.replaceAll("'", "");
    _files.add(path);
  }
  assetsAudioPlayer.open(
      Playlist(audios: [
        for (String f in _files) Audio.file(f),
      ]),
      loopMode: LoopMode.playlist //loop the full playlist
      );
  assetsAudioPlayer.stop();
  return assetsAudioPlayer;
}
