import 'dart:async';

class LoginStream {
  StreamController loginController = StreamController<bool>.broadcast();
  Stream get loginStream => loginController.stream;

  void increment(bool login) {
    loginController.sink.add(login);
  }

  void dispose() {
    loginController.close();
  }
}
