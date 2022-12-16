import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:id3/id3.dart';
import 'package:path_provider/path_provider.dart';

Future<List<String>> getPlayListLocal() async {
  List<String> playList = [];
  final appDocDir = await getExternalStorageDirectory();
  final filePathMp3 = appDocDir!.path;

  Directory dir = Directory(filePathMp3);
  String mp3Path = dir.toString();
  List<FileSystemEntity> _files;
  List<FileSystemEntity> files = [];
  String path = "";

  _files = dir.listSync(recursive: true, followLinks: true);
  // var a = readMata(filePathMp3);
  // print(a);
  for (FileSystemEntity entity in _files) {
    String path = entity.path;
    if (path.endsWith('.mp3')) {
      playList.add(path);
    }
  }
  if (playList.isEmpty) {
    return playList;
  }

  for (FileSystemEntity f in files) {
    path = f.toString().replaceAll("File: '", "");
    path = path.replaceAll("'", "");
    playList.add(path);
  }
  readMata(playList[0]);
  return playList;
}

Map<String, dynamic>? readMata(String file) {
  List<int> mp3Bytes = File(file).readAsBytesSync();
  MP3Instance mp3instance = new MP3Instance(mp3Bytes);

  /// parseTagsSync() returns
  // 'true' if successfully parsed
  // 'false' if was unable to recognize tag so can't be parsed
  Map<String, dynamic>? meta = Map();
  if (mp3instance.parseTagsSync()) {
    print(mp3instance.getMetaTags());
    meta = mp3instance.getMetaTags();
    return meta;
  }
  return null;
}

void playMusicIndex(AssetsAudioPlayer assetsAudioPlayer, String path) {
  assetsAudioPlayer.open(
    Audio.file(path),
    showNotification: true,
  );
}
