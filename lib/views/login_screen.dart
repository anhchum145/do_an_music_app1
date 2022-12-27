import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:do_an_music_app1/repositories/StreamAlbum.dart';
import 'package:do_an_music_app1/repositories/save_name_index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen(this.context, this.stream, {Key? key}) : super(key: key);
  BuildContext context;
  MyStream stream;
  bool loginDone = false;
  @override
  Widget build(BuildContext context) {
    String? emailSave = "";
    String? passSave = "";
    return FlutterLogin(
      title: 'MUSIC',
      onLogin: (p0) async {
        try {
          final login = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: p0.name,
            password: p0.password,
          );
          loginDone = true;
          saveEmail(p0.name);
          savePass(p0.password);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Đăng nhập thành công"),
            ),
          );
        } on FirebaseAuthException catch (e) {
          loginDone = false;
          if (e.code == 'user-not-found') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Không tìm thấy email mời đăng nhập lại"),
              ),
            );
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Mật khẩu sai mời đăng nhập lại"),
              ),
            );
            print('Wrong password provided for that user.');
          }
        }
      },
      onSignup: (p0) async {
        try {
          final login = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: p0.name.toString(), password: p0.password.toString());
          final doc = FirebaseFirestore.instance;
          final docc = doc.collection("user").doc(p0.name.toString());
          await docc.set({});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Đăng ký thành công"),
            ),
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Email đã tồn tại"),
              ),
            );
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Mật khẩu sai mời đăng nhập lại"),
              ),
            );
            print('Wrong password provided for that user.');
          }
        }
      },
      loginAfterSignUp: true,
      onSubmitAnimationCompleted: () {
        // Navigator.pop(context);
        // stream.increment("love");

        Navigator.pop(context, true);
      },
      messages: LoginMessages(confirmSignupSuccess: "Đăng nhập thành công"),
      savedEmail: emailSave,
      savedPassword: passSave,
      onRecoverPassword: (String) {
        return null;
      },
    );
  }
}
