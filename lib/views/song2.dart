import 'dart:isolate';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/repositories/StreamAlbum.dart';
import 'package:do_an_music_app1/repositories/download.dart';
import 'package:do_an_music_app1/repositories/service.dart';
import 'package:do_an_music_app1/views/album.dart';
import 'package:do_an_music_app1/views/listSong.dart';
import 'package:do_an_music_app1/views/player_bar.dart';
import 'package:do_an_music_app1/views/playingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:group_button/group_button.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:miniplayer/miniplayer.dart';
import '../repositories/loginStateStream.dart';
import '../repositories/readFromFirestore.dart';
import 'appbar.dart';

// ignore: must_be_immutable
class ListSong extends StatefulWidget {
  const ListSong(this.listLove, this.assetsAudioPlayer, {super.key});
  final AssetsAudioPlayer assetsAudioPlayer;
  final List<String> listLove;

  @override
  State<ListSong> createState() => _ListSongState(listLove, assetsAudioPlayer);
}

class _ListSongState extends State<ListSong> {
  _ListSongState(this.listLove, this.assetsAudioPlayer);
  int indexScreen = 0;
  playListModle? playApbar;
  ValueNotifier<int> valueNotifierIndexScreen = ValueNotifier(0);
  ValueNotifier<String> valueNotifierAlbum = ValueNotifier("full");
  ValueNotifier<bool> valueNotifierIndexSong = ValueNotifier(false);

  final AssetsAudioPlayer assetsAudioPlayer;
  playListModle? playList;
  playListModle? playListOffline;
  playListModle? playListLove;
  List<String> listLove;
  List<Map<String, String>> albumList = [];
  LoginStream loginStream = LoginStream();
  bool isConnect = true;
  MyStream streamAlbum = MyStream();
  final ReceivePort _port = ReceivePort();
  var userEmail = FirebaseAuth.instance.currentUser;
  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!isConnect) {
      valueNotifierIndexScreen.value = 2;
    } else {
      streamAlbum.albumStream.listen((event) {
        valueNotifierAlbum.value = event;
        playList = null;
        valueNotifierIndexScreen.value = 0;
      });
      assetsAudioPlayer.current.listen((event) {
        if (event != null) {
          valueNotifierIndexSong.value = true;
        }
      });
      loginStream.loginStream.listen(
        (event) {
          setState(
            () async {
              userEmail = FirebaseAuth.instance.currentUser;

              valueNotifierIndexScreen.value = 10;
              playListLove = null;
              if (userEmail != null) {
                listLove = await readListLoveStore(userEmail!.email.toString());
                valueNotifierIndexScreen.value = 0;

                setState(() {});
              } else {
                listLove = [];
                valueNotifierIndexScreen.value = 0;
                setState(() {});
              }
            },
          );
        },
      );
      InternetConnectionChecker().onStatusChange.listen((status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            if (!isConnect) {
              setState(() {
                isConnect = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Thiết bị hiện có kết nối Internet!"),
                ),
              );
            }
            break;
          case InternetConnectionStatus.disconnected:
            setState(() {
              {
                if (isConnect) isConnect = false;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      "Thiết bị hiện không có kết nối Internet!\nKhông thể nghe online!"),
                ),
              );
              // controller.disableIndexes([]);
            });
            break;
        }
      });
    }
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    getPlaylistDowloaded().then((value) => playListOffline = value);
    readPlayListFromStore(userEmail.toString(), true)
        .then((value) => playListLove = value);
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  Widget build(BuildContext context) {
    GroupButtonController controller = GroupButtonController();
    int selectedIndex = valueNotifierIndexScreen.value;
    Function onTap() {
      return () => setState(() {});
    }

    controller.selectIndex(isConnect ? valueNotifierIndexScreen.value : 2);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar(context, "Music", streamAlbum, loginStream),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 80),
                height: 150,
                child: GroupButton(
                  controller: controller,
                  isRadio: true,
                  buttons: const ["Home", "Album", "Download", "Yêu thích"],
                  options: GroupButtonOptions(
                    spacing: 10,
                    selectedShadow: const [],
                    selectedColor: Colors.black,
                    unselectedShadow: const [],
                    unselectedColor: Colors.black,
                    unselectedTextStyle: TextStyle(
                      color: Colors.grey[600],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onSelected: (val, i, selected) {
                    if (!isConnect) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Thiết bị hiện không có kết nối Internet!\nKhông thể nghe online!"),
                        ),
                      );
                    }
                    print(i);
                    if (i == 1) {
                      valueNotifierIndexScreen.value = 1;
                    }
                    if (i == 2) {
                      valueNotifierIndexScreen.value = 2;
                    }
                    if (i == 0) {
                      valueNotifierIndexScreen.value = 0;
                    }
                    if (i == 3) valueNotifierIndexScreen.value = 3;
                  },
                ),
              ),
              ValueListenableBuilder(
                valueListenable: valueNotifierIndexScreen,
                builder: (context, value, child) {
                  if (!isConnect) {
                    controller.disableIndexes([
                      0,
                      1,
                      3,
                    ]);
                    controller.selectIndex(2);
                    value = 2;
                  } else {
                    controller.disableIndexes([]);
                  }
                  switch (value) {
                    case 0:
                      {
                        if (playList != null) {
                          playApbar = playList;
                          playList!.mode = false;
                          return ListSongg(playList!, assetsAudioPlayer,
                              playListOffline!, listLove, false, () {
                            setState(() {});
                          });
                        } else {
                          return ValueListenableBuilder(
                            valueListenable: valueNotifierAlbum,
                            builder: (context, value, child) {
                              return FutureBuilder(
                                future: readPlayListFromStore(
                                    value.toString(), false),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    playList = snapshot.data as playListModle;
                                    playApbar = playList;
                                    return ListSongg(
                                        playList!,
                                        assetsAudioPlayer,
                                        playListOffline!,
                                        listLove,
                                        false,
                                        onTap());
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.cyanAccent,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.red),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          );
                        }
                      }
                      break;
                    case 1:
                      {
                        if (albumList.isNotEmpty) {
                          return AlbumWidget(albumList, context, streamAlbum);
                        } else {
                          return FutureBuilder(
                            future: readListAlbum(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                albumList =
                                    snapshot.data as List<Map<String, String>>;

                                return AlbumWidget(
                                    snapshot.data as List<Map<String, String>>,
                                    context,
                                    streamAlbum);
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.cyanAccent,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.red),
                                  ),
                                );
                              }
                            },
                          );
                        }
                      }
                      break;
                    case 2:
                      {
                        return ValueListenableBuilder(
                          valueListenable: valueNotifierAlbum,
                          builder: (context, value, child) {
                            return FutureBuilder(
                              future: getPlaylistDowloaded(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  playApbar = playListOffline;

                                  if (playList != null) playList!.mode = true;
                                  playListOffline =
                                      snapshot.data as playListModle;
                                  return ListSongg(
                                      playListOffline!,
                                      assetsAudioPlayer,
                                      playListOffline!,
                                      listLove,
                                      false,
                                      onTap());
                                } else {
                                  return Center(
                                    child: Text("Chưa có bài hát được tải!!"),
                                  );
                                }
                              },
                            );
                          },
                        );
                      }
                      break;
                    case 3:
                      {
                        if (userEmail != null) {
                          return FutureBuilder(
                            future: readPlayListFromStore(
                                userEmail!.email.toString(), true),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                playListLove = snapshot.data as playListModle;
                                return playListLove!.listSong.isNotEmpty
                                    ? ListSongg(
                                        playListLove!,
                                        assetsAudioPlayer,
                                        playListOffline!,
                                        listLove,
                                        true,
                                        onTap())
                                    : const Center(
                                        child: Text(
                                            "Bạn chưa có bài hát yêu thích nào!"),
                                      );
                                ;
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.cyanAccent,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.red),
                                  ),
                                );
                              }
                            },
                          );
                        } else {
                          return const Center(
                            child: Text("Đăng nhập để sửa dụng chức năng"),
                          );
                        }
                      }
                      break;

                    default:
                      {
                        return FutureBuilder(
                          future: getPlaylistDowloaded(),
                          builder: (context, snapshot1) {
                            if (snapshot1.hasData) {
                              return ListSongg(
                                  snapshot1.data as playListModle,
                                  assetsAudioPlayer,
                                  playListOffline!,
                                  listLove,
                                  false,
                                  onTap());
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.cyanAccent,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                              );
                            }
                          },
                        );
                      }
                      break;
                  }
                },
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: valueNotifierIndexSong,
            builder: (context, value, child) {
              if (value == true) {
                int index = 0;
                if (assetsAudioPlayer != null) {
                  index = assetsAudioPlayer.current.value!.index;
                }
                return Miniplayer(
                  minHeight: 50,
                  maxHeight: MediaQuery.of(context).size.height,
                  builder: (height, percentage) {
                    valueNotifierIndexSong.value = false;

                    if (height > MediaQuery.of(context).size.height - 100) {
                      return player(
                          playList,
                          index,
                          assetsAudioPlayer,
                          assetsAudioPlayer.isPlaying.value ? false : true,
                          false);
                    } else if (height <
                            MediaQuery.of(context).size.height - 100 &&
                        height > 50) {
                      return SizedBox();
                    } else {
                      return PlayerBar(context, assetsAudioPlayer, playApbar);
                    }
                  },
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
