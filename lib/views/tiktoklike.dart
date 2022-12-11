// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:do_an_music_app1/views/playingScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:tiktoklikescroller/tiktoklikescroller.dart';

// import '../model/playListModle.dart';

// Widget TiktokScroll(playListModle playList, int index1,
//     AssetsAudioPlayer assetsAudioPlayer, bool isPlay) {
//   final List<Color> colors = <Color>[Colors.red, Colors.blue, Colors.green];
//   final Controller controller = Controller()
//     ..addListener((event) {
//       _handleCallbackEvent(event.direction, event.success);
//     });
//   return TikTokStyleFullPageScroller(
//     contentSize: assetsAudioPlayer.playlist!.audios.length.toInt(),
//     swipePositionThreshold: 0.2,

//     // ^ the fraction of the screen needed to scroll
//     // swipeVelocityThreshold: 2000,
//     // ^ the velocity threshold for smaller scrolls
//     animationDuration: const Duration(milliseconds: 400),
//     // ^ how long the animation will take
//     controller: controller,
//     // ^ registering our own function to listen to page changes
//     builder: (BuildContext context, int index) {
//       if (assetsAudioPlayer.audioSessionId != 0)
//         assetsAudioPlayer = AssetsAudioPlayer.withId("0");
//       return player(playList, index, assetsAudioPlayer, false);
//     },
//   );
// }

// void _handleCallbackEvent(ScrollDirection direction, ScrollSuccess success,
//     {int? currentIndex}) {
//   print(
//       "Scroll callback received with data: {direction: $direction, success: $success and index: ${currentIndex ?? 'not given'}}");
// }
