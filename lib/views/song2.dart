// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:do_an_music_app1/model/playListModle.dart';
import 'package:do_an_music_app1/repositories/StreamAlbum.dart';
import 'package:do_an_music_app1/repositories/download.dart';
import 'package:do_an_music_app1/repositories/music_repository.dart';
import 'package:do_an_music_app1/repositories/service.dart';
import 'package:do_an_music_app1/views/album.dart';
import 'package:do_an_music_app1/views/listSong.dart';

import 'package:do_an_music_app1/views/menu.dart';
import 'package:do_an_music_app1/views/player_bar.dart';
import 'package:do_an_music_app1/views/playingScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:group_button/group_button.dart';
import 'package:miniplayer/miniplayer.dart';
import '../repositories/readFromFirestore.dart';
import 'appbar.dart';

// ignore: must_be_immutable
class ListSong extends StatefulWidget {
  ListSong(this.assetsAudioPlayer);
  final AssetsAudioPlayer assetsAudioPlayer;
  @override
  State<ListSong> createState() => _ListSongState(this.assetsAudioPlayer);
}

class _ListSongState extends State<ListSong> {
  _ListSongState(this.assetsAudioPlayer);
  int indexScreen = 0;
  ValueNotifier<int> valueNotifierIndexScreen = ValueNotifier(0);
  ValueNotifier<String> valueNotifierAlbum = ValueNotifier("full");
  ValueNotifier<bool> valueNotifierIndexSong = ValueNotifier(false);

  final AssetsAudioPlayer assetsAudioPlayer;
  playListModle? playList;
  playListModle? playListOffline;
  List<Map<String, String>> albumList = [];
  MyStream streamAlbum = MyStream();
  final ReceivePort _port = ReceivePort();
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
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });
    streamAlbum.albumStream.listen((event) {
      valueNotifierAlbum.value = event;
      playList = null;
      valueNotifierIndexScreen.value = 3;
    });
    assetsAudioPlayer.current.listen((event) {
      if (event != null) {
        valueNotifierIndexSong.value = true;
      }
    });
    getPlaylistDowloaded().then((value) => playListOffline = value);

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar("Music"),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 80),
                height: 150,
                child: GroupButton(
                  isRadio: true,
                  buttons: const ["Home", "Album", "Download"],
                  options: GroupButtonOptions(
                    spacing: 50,
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
                  },
                ),
              ),
              ValueListenableBuilder(
                valueListenable: valueNotifierIndexScreen,
                builder: (context, value, child) {
                  switch (value) {
                    case 0:
                      {
                        if (playList != null) {
                          playList!.mode = false;
                          return ListSongg(
                              playList!, assetsAudioPlayer, playListOffline!);
                        } else {
                          return ValueListenableBuilder(
                            valueListenable: valueNotifierAlbum,
                            builder: (context, value, child) {
                              return FutureBuilder(
                                future: readPlayListFromStore(value.toString()),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    playList = snapshot.data as playListModle;
                                    return ListSongg(playList!,
                                        assetsAudioPlayer, playListOffline!);
                                  } else {
                                    return Center(
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
                                return Center(
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
                                  playList!.mode = true;
                                  playListOffline =
                                      snapshot.data as playListModle;
                                  return ListSongg(playListOffline!,
                                      assetsAudioPlayer, playListOffline!);
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
                        return ValueListenableBuilder(
                          valueListenable: valueNotifierAlbum,
                          builder: (context, value, child) {
                            return FutureBuilder(
                              future: readPlayListFromStore(value.toString()),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  playList = snapshot.data as playListModle;
                                  return ListSongg(playList!, assetsAudioPlayer,
                                      playListOffline!);
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.cyanAccent,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.red),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
                      }
                      break;

                    default:
                      {
                        return FutureBuilder(
                          future: getPlaylistDowloaded(),
                          builder: (context, snapshot1) {
                            if (snapshot1.hasData) {
                              return ListSongg(snapshot1.data as playListModle,
                                  assetsAudioPlayer, playListOffline!);
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.cyanAccent,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.red),
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
              // Row(
              //   children: [
              //     Expanded(child: PlayerBar(context, assetsAudioPlayer, playList))
              //   ],
              // )
            ],
          ),
          ValueListenableBuilder(
            valueListenable: valueNotifierIndexSong,
            builder: (context, value, child) {
              if (value == true) {
                int index = assetsAudioPlayer.current.value!.index;
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
                      return PlayerBar(context, assetsAudioPlayer,
                          playList!.mode ? playListOffline : playList);
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

double heigtValue(bool i) {
  if (i == true) {
    return 50;
  } else {
    return 700;
  }
}
