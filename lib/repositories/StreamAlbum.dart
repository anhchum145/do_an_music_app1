import 'dart:async';

class MyStream {
  String album = "full";
  StreamController albumController = new StreamController<String>.broadcast();
  Stream get albumStream => albumController.stream;

  void increment(String album) {
    albumController.sink.add(album);
  }

  void dispose() {
    albumController.close();
  }
}
