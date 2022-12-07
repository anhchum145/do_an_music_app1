// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/model/songModel.dart';
import 'package:do_an_music_app1/repositories/service.dart';
import 'package:do_an_music_app1/views/album.dart';
import 'package:do_an_music_app1/views/player_bar.dart';
import 'package:do_an_music_app1/views/playingScreen.dart';

import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:miniplayer/miniplayer.dart';

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
    assetsAudioPlayer.current.listen((event) {
      setState(() {
        if (event != null) this.index = event.index.toInt();
        assetsAudioPlayer.isPlaying.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int index1 = index;
    listanIndex();
    final GroupButtonController controller = GroupButtonController();
    // controller.selectIndexes([0, 1, 2]);
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
                    buttons: const ["Album", "Download"],
                    options: GroupButtonOptions(
                      spacing: 50,
                      selectedShadow: const [],
                      selectedColor: Colors.black,
                      unselectedShadow: const [],
                      unselectedColor: Colors.grey[300],
                      unselectedTextStyle: TextStyle(
                        color: Colors.grey[600],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    onSelected: (val, i, selected) {
                      setState(() {
                        this.isPlay = false;
                      });
                    }),
              ),
              Expanded(
                child: isPlay
                    ? ListView.builder(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      song.coverlink,
                                      width: 70,
                                      loadingBuilder:
                                          (context, child, loadingProgress) =>
                                              (loadingProgress == null)
                                                  ? child
                                                  : CircularProgressIndicator(
                                                      strokeWidth: 2.0),
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset("assets/cover.jpg"),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  this.isPlay = true;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return player(playList, index,
                                          assetsAudioPlayer, true);
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                    : FutureBuilder(
                        future: readListAlbum(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return AlbumScreen(
                                snapshot.data as List<Map<String, String>>);
                          } else {
                            return MaterialApp(
                              home: Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.cyanAccent,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.red),
                                ),
                              ),
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        ),
        Miniplayer(
          minHeight: 50,
          maxHeight: 700,
          builder: (heigt, percentage) {
            return heigt < 500
                ? PlayerBar(context, assetsAudioPlayer, song, isPlay)
                : player(playList, index1, assetsAudioPlayer, false);
          },
        ),
      ],
    );
  }
}

double heigtValue(bool i) {
  if (i == true)
    return 50;
  else
    return 700;
}
