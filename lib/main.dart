import 'dart:io';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_music_app1/model/getPlayList.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/model/songModel.dart';
import 'package:do_an_music_app1/repositories/music_repository.dart';
import 'package:do_an_music_app1/repositories/readFromFirestore.dart';
import 'package:do_an_music_app1/repositories/service.dart';
import 'package:do_an_music_app1/repositories/write_db.dart';
import 'package:do_an_music_app1/views/homeScreen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:id3/id3.dart';

Future<void> main() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidDebugProvider: true,
  );
  final assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  // playListModle play = new playListModle(name: "ndv", listSong: []);

  // //ghiallsong

  //await metaDataUp();
  //--upic
  final storage = FirebaseStorage.instance.ref();
  final storageFolder = storage.child("/pic/cover");
  final listResult = await storageFolder.listAll();
  final docr = await FirebaseFirestore.instance.collection("playlist").get();
  final a = docr.docs;

  var t = await readListAlbum();

  print(t);
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

  runApp(MyApp(assetsAudioPlayer, a, 0));

  // await readPlayListFromStore("full").then((value) {
  //   return value;
  // });
}

class MyApp extends StatelessWidget {
  MyApp(this.assetsAudioPlayer, this.listAlbum, this.i);
  final AssetsAudioPlayer assetsAudioPlayer;
  var t = false;
  final listAlbum;
  final i;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readPlayListFromStore(listAlbum[i].id),
      builder: (context, AsyncSnapshot<playListModle> snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(brightness: Brightness.dark),
            home: HomePage(
              index: 0,
              isWidget: false,
              playList: snapshot.data,
              assetsAudioPlayer: assetsAudioPlayer,
            ),
          );
        } else {
          return MaterialApp(
            home: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.cyanAccent,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
          );
        }
      },
    );
  }
}

void fileToList(_files, files) {
  for (FileSystemEntity f in files) {
    var path = f.toString().replaceAll("File: '", "");
    path = path.replaceAll("'", "");
    _files.add(path);
  }
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
