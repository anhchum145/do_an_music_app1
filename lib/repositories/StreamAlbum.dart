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

  StreamController connectController = new StreamController<bool>.broadcast();
  Stream get connectStream => albumController.stream;

  void incrementConnect(bool state) {
    albumController.sink.add(album);
  }

  void disposeConnect() {
    albumController.close();
  }
}
