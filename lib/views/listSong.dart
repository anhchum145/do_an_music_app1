// ignore: file_names

import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/views/playingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../model/songModel.dart';
import '../repositories/download.dart';
import '../repositories/music_repository.dart';

// ignore: non_constant_identifier_names
Widget ListSongg(playListModle playList, AssetsAudioPlayer assetsAudioPlayer,
    playListModle isDown, List<String> listLove, bool isLove, Function onTap) {
  final user = FirebaseAuth.instance.currentUser;
  ValueNotifier<int> valueNotifier = ValueNotifier(0);
  return SizedBox(
    height: assetsAudioPlayer.current.hasValue ? 533.2 - 50 : 533.2,
    child: SizedBox(
      child: Positioned(
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
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    ValueListenableBuilder(
                      valueListenable: valueNotifier,
                      builder: (context, value, child) {
                        return !listLove.contains(song.id)
                            ? GestureDetector(
                                child: const Icon(
                                  Icons.star_border,
                                ),
                                onTap: () async {
                                  if (user != null) {
                                    final doc = FirebaseFirestore.instance;
                                    final docc = doc
                                        .collection("user")
                                        .doc(user.email.toString());
                                    docc.update({
                                      song.id.toString(): song.id.toString()
                                    });
                                    listLove.add(song.id);
                                    valueNotifier.value++;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Đã thêm vào danh sách yêu thích"),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Đăng nhập để sử dụng chức năng này!"),
                                      ),
                                    );
                                  }
                                },
                              )
                            : GestureDetector(
                                child: const Icon(
                                  Icons.star_border,
                                  color: Colors.red,
                                ),
                                onTap: () async {
                                  if (user != null) {
                                    final doc = FirebaseFirestore.instance;
                                    final docc = doc
                                        .collection("user")
                                        .doc(user.email.toString());
                                    await docc
                                        .get()
                                        .then((DocumentSnapshot doc) {
                                      var data =
                                          doc.data() as Map<String, dynamic>;
                                      data.forEach((key, value) async {
                                        if (value.toString().compareTo(
                                                song.id.toString()) ==
                                            0) {
                                          await docc.update(
                                              {key: FieldValue.delete()});
                                        }
                                      });
                                    });
                                    listLove.remove(song.id);
                                    valueNotifier.value++;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "Đã xoá khỏi danh sách yêu thích"),
                                      ),
                                    );
                                  }
                                },
                              );
                      },
                    ),
                    !isDownload(song, isDown)
                        ? GestureDetector(
                            child: const Icon(
                              Icons.download,
                            ),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Đang tải, theo dõi ở thanh trạng thái!!"),
                                ),
                              );
                              download(song);
                            },
                          )
                        : playList.mode
                            ? GestureDetector(
                                child: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Đang xoá"),
                                    ),
                                  );
                                  showAlertDialog(context, song, onTap);
                                  // deleteFile(File(song.path));
                                },
                              )
                            : const Icon(
                                Icons.download_done_rounded,
                                color: Colors.red,
                              ),
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

// Future<bool> checkLoved(String id, String email) async {

//   return docc.
//   }
showAlertDialog(BuildContext context, SongModel name, Function onTap) {
  // set up the buttons

  Widget continueButton = TextButton(
    child: const Text("Xoá", style: TextStyle(color: Colors.red)),
    onPressed: () {
      onTap();
      Navigator.of(context).pop();
      deleteFile(File(name.path));
    },
  );
  Widget cancelButton = TextButton(
    child: const Text("Huỷ"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Xác nhận xoá"),
    content: Text("Bạn có chắc muốn xoá bài $name ?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
