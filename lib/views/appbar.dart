import 'package:do_an_music_app1/repositories/StreamAlbum.dart';
import 'package:do_an_music_app1/repositories/loginStateStream.dart';
import 'package:do_an_music_app1/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget appBar(BuildContext context, String title, MyStream stream,
    LoginStream loginStream) {
  var user = FirebaseAuth.instance.currentUser;
  ValueNotifier<int> islogin = ValueNotifier(0);
  loginStream.loginStream.listen(
    (event) {
      user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        islogin.value++;
      } else
        islogin.value++;
    },
  );
  return AppBar(
    key: const Key("appBar"),
    backgroundColor: Colors.black,
    elevation: 100,
    actions: [
      Center(
        child: ValueListenableBuilder(
          valueListenable: islogin,
          builder: (context, value, child) => Text(user?.email == null
              ? "Bạn chưa đăng nhập!!"
              : "Xin chào ${user?.email}"),
        ),
      ),
      IconButton(
        onPressed: () async => user?.email == null
            ? await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(context, stream),
                ),
              ).then((value) => loginStream.increment(true))
            : {
                await FirebaseAuth.instance.signOut(),
                loginStream.loginController.sink.add(false),
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Đăng xuất thành công"),
                  ),
                ),
              },
        icon: ValueListenableBuilder(
          valueListenable: islogin,
          builder: (context, value, child) => user?.email == null
              ? const Icon(Icons.login)
              : const Icon(Icons.logout),
        ),
      ),
    ],
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w300,
      ),
    ),
  );
}
