import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/repositories/music_repository.dart';
import 'package:do_an_music_app1/repositories/readFromFirestore.dart';
import 'package:do_an_music_app1/views/homeScreen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:id3/id3.dart';

Future<void> main() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey:
        'ca:97:81:12:ca:1b:bd:ca:fa:c2:31:b3:9a:23:dc:4d:a7:86:ef:f8:14:7c:4e:72:b9:80:77:85:af:ee:48:bb',
    androidDebugProvider: true,
  );
  final assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  final musicRepoo = new musicRepo("music");
  // playListModle play =
  //     new playListModle(name: "E3w58hxFYnh7NWBkJIF3", listSong: null);

  //ghiallsong
  // playListModle p;
  // Future<playListModle> play =
  //     musicRepoo.getPlayListFromFolder("music").then((value) {
  //   for (SongModel s in value.listSong) {
  //     WriteSong(s);
  //   }
  //   return value;
  // });
  // WriteDate(play);
  runApp(MyApp(assetsAudioPlayer));

  // await readPlayListFromStore("full").then((value) {
  //   return value;
  // });
}

class MyApp extends StatelessWidget {
  MyApp(this.assetsAudioPlayer);
  final AssetsAudioPlayer assetsAudioPlayer;
  var t = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readPlayListFromStore("full"),
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

    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(brightness: Brightness.dark),
    //   home: HomePage(
    //     index: -1,
    //     isWidget: true,
    //     playList: play,
    //     assetsAudioPlayer: assetsAudioPlayer,
    //   ),
    // );
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
