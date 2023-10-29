// files
import 'package:todo2/model/variable_function.dart';
import 'package:todo2/pages/todo.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> loginButton(BuildContext context) async {
  try {
    // ログイン
    Model.instance.user = await Model.instance.logIn(
        LogInPageModel.instance.mailAddress, LogInPageModel.instance.password);

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Todo()));
  } on FirebaseAuthException catch (e) {
    // もしerror code　'user-not-found'ならメールアドレスがない
    if (e.code == 'user-not-found') {
      print("メアド見つからない");
      showDialog(
          // おまじない
          context: context,
          builder: (context) {
            return AlertDialog(
                // ウインドウ左上に表示させるもの
                title: Text("エラー"),
                // 内容入力
                content: Text("メールアドレスが見つかりません"),
                // ボタン。任意、書かなくてもいい
                actions: [
                  TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ]);
          });
      // もしerror code 'wrong-password'ならパスワード間違ってる
    } else if (e.code == 'wrong-password') {
      showDialog(
          // おまじない
          context: context,
          builder: (context) {
            return AlertDialog(
                // ウインドウ左上に表示させるもの
                title: Text("エラー"),
                // 内容入力
                content: Text("パスワードが違います"),
                // ボタン。任意、書かなくてもいい
                actions: [
                  TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ]);
          });
    }
    ;
  }
}
