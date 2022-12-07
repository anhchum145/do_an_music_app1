import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/views/album.dart';
import 'package:do_an_music_app1/views/playingScreen.dart';
import 'package:do_an_music_app1/views/song2.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage(
      {required this.isWidget,
      required this.playList,
      required this.index,
      required this.assetsAudioPlayer});
  playListModle? playList;
  bool isWidget = false;
  int index;
  final AssetsAudioPlayer assetsAudioPlayer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: !isWidget ? Colors.black : Colors.transparent,
        elevation: 100,
        actions: [
          IconButton(onPressed: null, icon: Icon(Icons.account_box)),
        ],
        title: const Text(
          "Music",
          style: TextStyle(
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: ListSong(playList, assetsAudioPlayer, true, index),

      // bottomNavigationBar: NavBar(),
    );
  }
}
