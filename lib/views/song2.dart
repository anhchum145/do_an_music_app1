// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/model/songModel.dart';
import 'package:do_an_music_app1/repositories/save_name_index.dart';
import 'package:do_an_music_app1/views/player_bar.dart';
import 'package:do_an_music_app1/views/playingScreen.dart';

import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:miniplayer/miniplayer.dart';

import 'homeScreen.dart';

class ListSong extends StatefulWidget {
  ListSong(this.playList, this.assetsAudioPlayer, this.isPlay, this.index);
  playListModle? playList;
  bool isWidget = false;
  bool isPlay = false;
  int index = 0;

  final AssetsAudioPlayer assetsAudioPlayer;
  @override
  State<ListSong> createState() => _ListSongState(
      this.playList, this.assetsAudioPlayer, this.isPlay, this.index);
}

class _ListSongState extends State<ListSong> {
  _ListSongState(
      this.playList, this.assetsAudioPlayer, this.isPlay, this.index);
  playListModle? playList;
  int index;
  final AssetsAudioPlayer assetsAudioPlayer;
  final List<FileSystemEntity> files = [];
  bool isPlay;
  @override
  void initState() {
    super.initState();
  }

  void listanIndex() async {
    if (assetsAudioPlayer.isPlaying.value) {
      assetsAudioPlayer.current.listen((event) {
        setState(() {
          if (event != null) this.index = event.index.toInt();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int index1 = index;
    listanIndex();
    SongModel song = playList!.listSong[index1];
    return Stack(
      children: [
        Container(
          height: 630,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 80),
                height: 150,
                child: GroupButton(
                  isRadio: true,
                  buttons: const ["BXH", "Album", "Download"],
                  options: GroupButtonOptions(
                    spacing: 50,
                    selectedShadow: const [],
                    unselectedShadow: const [],
                    unselectedColor: Colors.grey[300],
                    unselectedTextStyle: TextStyle(
                      color: Colors.grey[600],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onSelected: (val, i, selected) =>
                      debugPrint('Button: $val index: $i $selected'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 0),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  //if file/folder list is grabbed, then show here
                  itemCount: playList?.listSong.length,
                  itemBuilder: (context, index) {
                    SongModel song = playList!.listSong[index];
                    return Container(
                      padding: EdgeInsets.only(top: 10),
                      height: 80,
                      color: Colors.transparent,
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "assets/cover.jpg",
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 200.0,
                                ),
                                Flexible(
                                  child: Text(
                                    song.name.toString().length > 21
                                        ? "${song.name.toString().substring(0, 21)}..."
                                        : song.name.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  song.artist.toString().length > 28
                                      ? "${song.artist.toString().substring(0, 28)}..."
                                      : song.artist.toString(),
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.more_vert,
                            ),
                          ],
                        ),
                        // onTap: () {
                        //   setState(() {

                        //   });
                        // },
                        onTap: () {
                          setState(() {
                            this.index = index;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HomePage(
                                  isWidget: true,
                                  playList: playList,
                                  index: index,
                                  assetsAudioPlayer: assetsAudioPlayer,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );

                    // Card(
                    //   child:ListTile(
                    //      title: Text(files[index].index.split('/').last),
                    //      leading: Icon(Icons.audiotrack),
                    //      trailing: Icon(Icons.play_arrow, color: Colors.redAccent,),
                    //      onTap: (){
                    //         // you can add Play/push code over here
                    //      },
                    //   )
                    // );
                  },
                ),
              ),
            ],
          ),
        ),
        Miniplayer(
          backgroundColor: Colors.yellow,
          minHeight: !isPlay ? 50 : 700,
          maxHeight: 700,
          duration: assetsAudioPlayer.isPlaying.value
              ? assetsAudioPlayer.current.value!.audio.duration
              : new Duration(seconds: 0),
          builder: (height, percentage) {
            percentage = 100;
            return height < 500
                ? PlayerBar(context, assetsAudioPlayer, song)
                : player(playList, index1, assetsAudioPlayer, isPlay);
          },
        ),
      ],
    );
  }
}
