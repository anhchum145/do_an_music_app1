import 'dart:isolate';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/views/album.dart';
import 'package:do_an_music_app1/views/appbar.dart';
import 'package:do_an_music_app1/views/menu.dart';
import 'package:do_an_music_app1/views/playingScreen.dart';
import 'package:do_an_music_app1/views/song2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import '../repositories/service.dart';

class HomePage extends StatelessWidget {
  HomePage(
      {required this.mode,
      required this.index,
      required this.assetsAudioPlayer});

  int index;
  final AssetsAudioPlayer assetsAudioPlayer;
  bool mode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBar(mode ? "Download" : "Home"),
        body: ListSong(assetsAudioPlayer),

        // bottomNavigationBar: NavBar(),
      ),
      //routes: <String, WidgetBuilder>{
      // '/a': (context) => FutureBuilder(
      //       future: readListAlbum(),
      //       builder: (context, snapshot) {
      //         if (snapshot.hasData) {
      //           return AlbumScreen(
      //               snapshot.data as List<Map<String, String>>, context);
      //         } else {
      //           return Center(
      //             child: CircularProgressIndicator(
      //               backgroundColor: Colors.cyanAccent,
      //               valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
      //             ),
      //           );
      //         }
      //       },
      //     ),
      //   '/b': (context) => HomePage(
      //       mode: getIsOffline(),
      //       assetsAudioPlayer: assetsAudioPlayer,
      //       index: index),
      // },
    );
  }
}
