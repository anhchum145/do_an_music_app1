import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/model/songModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget PlayerBar(
    context, AssetsAudioPlayer assetsAudioPlayer, SongModel song, bool isPlay) {
  return Container(
    color: Colors.black87,
    child: FractionallySizedBox(
      heightFactor: .5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 10,
          ),
          // Song cover
          Center(
            child: Container(
              child: Image.network(
                song.coverlink,
                width: 40,
                loadingBuilder: (context, child, loadingProgress) =>
                    (loadingProgress == null)
                        ? child
                        : CircularProgressIndicator(),
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset("assets/cover.jpg"),
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
                song.name != null && isPlay
                    ? song.name.toString().length > 21
                        ? "${song.name.toString().substring(0, 15)}..."
                        : song.name.toString()
                    : "Mời chọn bài hát",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              // Artist
              // Text(
              //   "Unknown artist",
              //   style: Theme.of(context)
              //       .textTheme
              //       .bodyText2
              //       ?.copyWith(color: Colors.grey.withOpacity(.6)),
              // ),
            ],
          ),

          // Padding between first 2 columns and Icons
          Expanded(child: SizedBox.expand()),

          //
          // Play button and progress indicator
          //
          Container(
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
            child: GestureDetector(
              onTap: () {
                assetsAudioPlayer.playOrPause();
              },
              child: Icon(
                assetsAudioPlayer.isPlaying.value
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.red,
              ),
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
              child: Icon(
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
    ),
  );
}
