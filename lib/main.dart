import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_music_app1/repositories/readFromFirestore.dart';
import 'package:do_an_music_app1/repositories/save_name_index.dart';
import 'package:do_an_music_app1/views/song2.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  final assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  // playListModle play = new playListModle(name: "ndv", listSong: []);
  // await FirebaseAuth.instance.signOut();
  // //ghiallsong

  // // Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  final user = FirebaseAuth.instance.currentUser;
  List<String> listLove = [];
  if (user != null) {
    listLove = await readListLoveStore(user.email.toString());
  }

  //await metaDataUp();
  //--upic
  // final storage = FirebaseStorage.instance.ref();
  // final storageFolder = storage.child("/pic/cover");
  // final listResult = await storageFolder.listAll();
  // playListModle p;
  // await readPlayListFromStore("trehot").then(
  //   (value) async {
  //     List<String> link = [];

  //     for (var item in listResult.items) {
  //       final linkSong = await item.getDownloadURL();
  //       link.add(linkSong);
  //     }
  //     for (SongModel s in value.listSong) {
  //       s.coverlink = link[Random().nextInt(15) + 1];
  //       WriteSong(s);
  //     }
  //   },
  // );
  //--------------
  // await getPlayListFromFolder("/music/nhactrehot").then((value) {
  //   for (SongModel s in value.listSong) {
  //     WriteSong(s);
  //   }
  //   return value;
  // });
  //await WritePlay();
  // await getPlayListLocal().then((value) => print(value));
  runApp(MyApp(listLove, assetsAudioPlayer));
  // await readPlayListFromStore("full").then((value) {
  //   return value;
  // });
}

class MyApp extends StatelessWidget {
  MyApp(this.listLove, this.assetsAudioPlayer);
  final AssetsAudioPlayer assetsAudioPlayer;
  final List<String> listLove;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: ListSong(listLove, assetsAudioPlayer),
    );
    //HomePage(
    //mode: false, index: 0, assetsAudioPlayer: assetsAudioPlayer);
  }
}

void fileToList(_files, files) {
  for (FileSystemEntity f in files) {
    var path = f.toString().replaceAll("File: '", "");
    path = path.replaceAll("'", "");
    _files.add(path);
  }
}

// Map<String, dynamic>? readMata(String file) {
//   List<int> mp3Bytes = File(file).readAsBytesSync();
//   MP3Instance mp3instance = new MP3Instance(mp3Bytes);

//   /// parseTagsSync() returns
//   // 'true' if successfully parsed
//   // 'false' if was unable to recognize tag so can't be parsed
//   Map<String, dynamic>? meta = Map();
//   if (mp3instance.parseTagsSync()) {
//     print(mp3instance.getMetaTags());
//     meta = mp3instance.getMetaTags();
//     return meta;
//   }
//   return null;
// }
