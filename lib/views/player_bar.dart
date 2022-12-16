import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/model/songModel.dart';
import 'package:flutter/material.dart';

Widget PlayerBar(
    context, AssetsAudioPlayer assetsAudioPlayer, playListModle? playList) {
  SongModel? song = playList!.listSong[assetsAudioPlayer.current.value!.index];
  ValueNotifier<bool> isplay = ValueNotifier(true);
  return FractionallySizedBox(
    heightFactor: .5,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 10,
        ),

        Center(
          child: Container(
            child: playList.mode == false
                ? Image.network(
                    song.coverlink,
                    width: 40,
                    loadingBuilder: (context, child, loadingProgress) =>
                        (loadingProgress == null)
                            ? child
                            : CircularProgressIndicator(),
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      "assets/cover.png",
                    ),
                  )
                : Image.asset(
                    "assets/cover.png",
                  ),
          ),
        ),
        // Padding
        SizedBox(width: 15),

        // Title and artist
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              song.name != null
                  ? song.name.toString().length > 21
                      ? "${song.name.toString().substring(0, 15)}..."
                      : song.name.toString()
                  : "Mời chọn bài hát",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),

        // Padding between first 2 columns and Icons
        const Expanded(child: SizedBox.expand()),

        //
        // Play button and progress indicator
        //
        SizedBox(
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              assetsAudioPlayer.previous();
            },
            child: Icon(
              Icons.skip_previous,
              color: Colors.red,
            ),
          ),
        ),
        SizedBox(width: 8),

        Container(
          width: 40,
          height: 40,
          child: ValueListenableBuilder(
            valueListenable: isplay,
            builder: (BuildContext context, dynamic value, Widget? child) {
              return Container(
                child: GestureDetector(
                  onTap: () {
                    assetsAudioPlayer.playOrPause();
                    if (assetsAudioPlayer.isPlaying.value) {
                      isplay.value = false;
                    } else {
                      isplay.value = true;
                    }
                  },
                  child: Icon(
                    value ? Icons.pause : Icons.play_arrow,
                    color: Colors.red,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(width: 8),

        Container(
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              assetsAudioPlayer.next();
            },
            child: const Icon(
              Icons.skip_next,
              color: Colors.red,
            ),
          ),
        ),
        //
        SizedBox(width: 8),
        // Extra padding at the end of the row
        SizedBox(width: 30),
      ],
    ),
  );
}
