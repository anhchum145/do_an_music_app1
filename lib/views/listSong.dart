// ignore: file_names
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/views/playingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../model/songModel.dart';
import '../repositories/download.dart';
import '../repositories/music_repository.dart';

// ignore: non_constant_identifier_names
Widget ListSongg(playListModle playList, AssetsAudioPlayer assetsAudioPlayer,
    playListModle isDown) {
  return SizedBox(
    height: assetsAudioPlayer.current.hasValue ? 533.2 - 50 : 533.2,
    child: SizedBox(
      child: Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 0),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          //if file/folder list is grabbed, then show here
          itemCount: playList.listSong.length,
          itemBuilder: (context, index) {
            SongModel song = playList.listSong[index];
            return Container(
              padding: const EdgeInsets.only(top: 10),
              height: 80,
              color: Colors.transparent,
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: !playList.mode
                          ? Image.network(song.coverlink,
                              width: 70,
                              loadingBuilder:
                                  (context, child, loadingProgress) =>
                                      (loadingProgress == null)
                                          ? child
                                          : Image.asset("assets/cover.png",
                                              width: 70),
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset("assets/cover.png",
                                    width: 70);
                              })
                          : Image.asset("assets/cover.png", width: 70),
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(
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
                    !isDownload(song, isDown)
                        ? GestureDetector(
                            child: const Icon(
                              Icons.download,
                            ),
                            onTap: () => download(song),
                          )
                        : const Icon(Icons.download_done_sharp),
                  ],
                ),
                onTap: () {
                  index = index;

                  getAPlayList(playList.mode, playList, assetsAudioPlayer);
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    // add your code here.

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return player(
                              playList, index, assetsAudioPlayer, true, true);
                        },
                      ),
                    );
                  });
                },
              ),
            );
          },
        ),
      ),
    ),
  );
}

bool isDownload(SongModel song, playListModle playDowned) {
  for (var s in playDowned.listSong) {
    if (s.name.contains(song.name)) return true;
  }
  return false;
}
