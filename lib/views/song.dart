// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'getPlaylist.dart';

class ListSong extends StatefulWidget {
  bool isWidget = true;

  @override
  State<ListSong> createState() => _ListSongState();
}

class _ListSongState extends State<ListSong> {
  List<FileSystemEntity> files = [];
  List<String> paths = [];

  @override
  void initState() {
    paths = getFullSong();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        //padding: EdgeInsets.only(top: 10),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        //if file/folder list is grabbed, then show here
        itemCount: paths.length,
        itemBuilder: (context, index) {
          // Map<String, dynamic>? meta = readMata(paths[index]);
          return Container(
            padding: EdgeInsets.only(top: 10),
            height: 80,
            color: Colors.transparent,
            child: Text("ts"),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         ClipRRect(
            //           borderRadius: BorderRadius.circular(10),
            //           child: Image.asset(
            //             "assets/cover.jpg",
            //           ),
            //         ),
            //         Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             SizedBox(
            //               width: 200.0,
            //             ),
            //             Flexible(
            //               child: Text(
            //                 meta!["Title"].toString().length > 25
            //                     ? "${meta["Title"].toString().substring(0, 25)}..."
            //                     : meta["Title"].toString(),
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.w400,
            //                 ),
            //               ),
            //             ),
            //             SizedBox(
            //               height: 15,
            //             ),
            //             Text(
            //               meta["Artist"].toString().length > 28
            //                   ? "${meta["Artist"].toString().substring(0, 28)}..."
            //                   : meta["Artist"].toString(),
            //               style: TextStyle(
            //                 color: Colors.white54,
            //                 fontSize: 12,
            //                 fontWeight: FontWeight.w400,
            //               ),
            //             ),
            //           ],
            //         ),
            //         Icon(
            //           Icons.more_vert,
            //         ),
            //       ],
            //     ),
            //     onTap: () {
            //       // Navigator.push(
            //       //   context,
            //       //   MaterialPageRoute(
            //       //     builder: (context) {
            //       //       return HomePage(
            //       //         isWidget: false,
            //       //         index: index,
            //       //       );
            //       //     },
            //       //   ),
            //       // );
            //     },
            //   ),
            // );

            // Card(
            //   child:ListTile(
            //      title: Text(files[index].index.split('/').last),
            //      leading: Icon(Icons.audiotrack),
            //      trailing: Icon(Icons.play_arrow, color: Colors.redAccent,),
            //      onTap: (){
            //         // you can add Play/push code over here
            //      },
            //   )
          );
        },
      ),
    );

    ListView(
      children: [],
    );
  }
}
