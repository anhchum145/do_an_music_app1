import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/model/songModel.dart';
import 'package:do_an_music_app1/repositories/music_repository.dart';
import 'package:do_an_music_app1/views/homeScreen.dart';

import 'package:flutter/material.dart';

class player extends StatefulWidget {
  player(this.playList, this.index, this.assetsAudioPlayer, this.isPlay);
  playListModle? playList;
  bool isPlay;
  int index;
  // bool isPlay;
  final AssetsAudioPlayer assetsAudioPlayer;
  @override
  State<player> createState() =>
      _playerState(playList, index, assetsAudioPlayer, isPlay);
}

class _playerState extends State<player> {
  _playerState(this.playList, this.index, this.assetsAudioPlayer, this.isPlay);
  playListModle? playList;
  AssetsAudioPlayer assetsAudioPlayer;
  bool isPlay;
  Duration? duration = Duration(seconds: 0);
  Duration? duration1 = Duration(seconds: 0);
  int index;
  int mui = 0;
  double sec = 0;
  @override
  void initState() {
    if (isPlay) {
      if (this.assetsAudioPlayer.id != "0") {
        this.assetsAudioPlayer.dispose();
        this.assetsAudioPlayer = new AssetsAudioPlayer.withId("0");
      }
      if (assetsAudioPlayer.playlist == null) {
        getAPlayList(playList!, assetsAudioPlayer);
      }
      assetsAudioPlayer.playlistPlayAtIndex(index);
    }
  }

  // void getDuration() {
  //   if (assetsAudioPlayer.isPlaying.value) {
  //     duration = assetsAudioPlayer.current.value?.audio.duration;
  //   } else
  //     duration = Duration(seconds: 0);
  // }

  void listenSlider() async {
    assetsAudioPlayer.currentPosition.listen(
      (playingAudio) {
        setState(() {
          mui = playingAudio.inMinutes.toInt();
          sec = playingAudio.inSeconds.toDouble();
        });
      },
    );
  }

  void listanIndex() async {
    if (assetsAudioPlayer.isPlaying.value) {
      assetsAudioPlayer.current.listen((event) {
        setState(() {
          duration = assetsAudioPlayer.current.value!.audio.duration;
          this.index = event!.index.toInt();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final SongModel song = playList.listSong![index];
    Duration? duration1 = Duration(seconds: 0);
    // getDuration();
    listanIndex();

    listenSlider();
    SongModel song = playList!.listSong[index];
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(song.coverlink),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black54,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  isPlay
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_outlined,
                            color: Colors.white,
                          ),
                        )
                      : SizedBox(
                          width: 20,
                        ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  song.coverlink,
                  width: 280,
                  loadingBuilder: (context, child, loadingProgress) =>
                      (loadingProgress == null)
                          ? child
                          : CircularProgressIndicator(),
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset("assets/cover.jpg"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                song.name.toString().length > 17
                    ? "${song.name.toString().substring(0, 17)}..."
                    : song.name.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  letterSpacing: 6,
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${mui.floor().toString().padLeft(2, "0")}:${(sec % 60).floor().toString().padLeft(2, "0")}",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Slider.adaptive(
                    min: 0.0,
                    max:
                        duration == null ? 0.0 : duration!.inSeconds.toDouble(),
                    value: sec,
                    onChanged: (value) {
                      setState(
                        () {
                          assetsAudioPlayer
                              .seekBy(new Duration(seconds: value.toInt()));
                          assetsAudioPlayer.play();
                        },
                      );
                    },
                    activeColor: Colors.white,
                  ),
                  Text(
                    assetsAudioPlayer.isPlaying.value
                        ? "${duration?.inMinutes.floor().toString().padLeft(2, "0")}:${(duration!.inSeconds % 60).floor().toString().padLeft(2, "0")}"
                        : "00:00",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              assetsAudioPlayer.previous();
                            },
                          );
                        },
                        child: Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.black,
                          border: Border.all(
                            color: Colors.pink,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            duration1 = duration;

                            setState(() {
                              assetsAudioPlayer.playOrPause();
                            });
                          },
                          child: Center(
                            child: Icon(
                              assetsAudioPlayer.isPlaying.value
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              assetsAudioPlayer.next();
                            },
                          );
                        },
                        child: Icon(
                          Icons.skip_next,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }
}
