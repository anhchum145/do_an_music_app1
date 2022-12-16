import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/model/songModel.dart';
import 'package:flutter/material.dart';

import '../repositories/music_repository.dart';

class player extends StatelessWidget {
  player(
      this.playList, this.index, this.assetsAudioPlayer, this.isPlay, this.call,
      {super.key});
  playListModle? playList;
  bool isPlay;
  int index;
  bool call;
  AssetsAudioPlayer assetsAudioPlayer;
  Duration? duration = Duration(seconds: 0);
  Duration? duration1 = Duration(seconds: 0);
  int mui = 0;
  double sec = 0;
  ValueNotifier<int> valueNotifierIndex = ValueNotifier(0);
  ValueNotifier<double> valueNotifierSlider = ValueNotifier(0);
  ValueNotifier<int> valueNotifier = ValueNotifier(0);
  void listenSlider() async {
    assetsAudioPlayer.currentPosition.listen(
      (playingAudio) {
        if (index != assetsAudioPlayer.current.value!.index) {
          index = assetsAudioPlayer.current.value!.index;
          valueNotifierIndex.value = index;
        }
        duration = assetsAudioPlayer.current.value!.audio.duration;
        valueNotifierSlider.value = playingAudio.inSeconds.toDouble();
        mui = playingAudio.inMinutes.toInt();
        sec = playingAudio.inSeconds.toDouble();
      },
    );
  }

  Future<void> ini() async {
    if (call) {
      if (assetsAudioPlayer.id != "0") {
        assetsAudioPlayer.dispose();
        assetsAudioPlayer = AssetsAudioPlayer.withId("0");
      }
      if (assetsAudioPlayer.playlist == null) {
        getAPlayList(playList!.mode, playList!, assetsAudioPlayer);
      }
      await assetsAudioPlayer.playlistPlayAtIndex(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    ini();
    listenSlider();
    bool isPlay = true;
    return Scaffold(
        body: ValueListenableBuilder(
      valueListenable: valueNotifierIndex,
      builder: (context, value, child) {
        SongModel song = playList!.listSong[index];

        return Stack(
          fit: StackFit.expand,
          children: [
            Container(
              constraints: const BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: !playList!.mode
                    ? DecorationImage(
                        image: NetworkImage(song.coverlink),
                        fit: BoxFit.cover,
                      )
                    : DecorationImage(
                        image: const AssetImage("assets/cover.png"),
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
                    call
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back_outlined,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox(
                            width: 20,
                          ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: !playList!.mode
                      ? Image.network(
                          song.coverlink,
                          width: 280,
                          loadingBuilder: (context, child, loadingProgress) =>
                              (loadingProgress == null)
                                  ? child
                                  : CircularProgressIndicator(),
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            "assets/cover.png",
                            width: 280,
                          ),
                        )
                      : Image.asset(
                          "assets/cover.png",
                          width: 280,
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
                    ValueListenableBuilder(
                      valueListenable: valueNotifierSlider,
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        return Text(
                          "${mui.floor().toString().padLeft(2, "0")}:${(sec % 60).floor().toString().padLeft(2, "0")}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: valueNotifierSlider,
                      builder: (context, value, child) {
                        return Slider.adaptive(
                          min: 0.0,
                          max: duration == null
                              ? 0.0
                              : duration!.inSeconds.toDouble(),
                          value: sec,
                          onChanged: (value) {
                            assetsAudioPlayer
                                .seekBy(Duration(seconds: value.toInt()));
                            assetsAudioPlayer.play();
                          },
                          activeColor: Colors.white,
                        );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: valueNotifierSlider,
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        return Text(
                          "${duration!.inMinutes.floor().toString().padLeft(2, "0")}:${(duration!.inSeconds % 60).floor().toString().padLeft(2, "0")}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            assetsAudioPlayer.previous();
                          },
                          child: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
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
                            onTap: () async {
                              await assetsAudioPlayer.playOrPause().then(
                                (value) {
                                  valueNotifier.value++;
                                },
                              );
                            },
                            child: Center(
                              child: ValueListenableBuilder(
                                valueListenable: valueNotifierSlider,
                                builder: (context, value, child) => Icon(
                                  assetsAudioPlayer.isPlaying.value
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            assetsAudioPlayer.next();
                          },
                          child: const Icon(
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
        );
      },
    ));
  }
}
