import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';

List<String> getFullSong() {
  Directory dir = Directory(
      '/storage/151B-0F19/Music/Nhung Bai Nhac Tre Hot Nhat Mot Thoi - Various Artists - Nhac.vn/');
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
