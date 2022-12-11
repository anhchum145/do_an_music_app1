import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_music_app1/model/songModel.dart';

class playListModle {
  String name;
  List<SongModel> listSong;
  String id;
  String pic;
  bool mode;

  playListModle(
      {required this.name,
      required this.listSong,
      required this.id,
      required this.pic,
      required this.mode});

  // factory playListModle.fromFirestore(
  //   DocumentSnapshot<Map<String, dynamic>> snapshot,
  //   SnapshotOptions? options,
  // ) {
  //   final data = snapshot.data();
  //   return playListModle(
  //     name: data?['name'],
  //     listSong:
  //         data?['listSong'] is Iterable ? List.from(data?['listSong']) : null,
  //   );
  // }

  // Map<String, Object?> toFirestore() {
  //   return {
  //     if (name != null) "name": name,
  //     if (listSong != null) "listsong": listSong,
  //   };
  // }
}
