import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo2/admob.dart';
import 'package:todo2/class_format.dart';
import 'package:todo2/pages/registration.dart';
import 'package:todo2/pages/todo.dart';
import 'package:todo2/variable_function.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log In Screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  "Simple To Do",
                  style: TextStyle(fontSize: 50),
                ),
                // Text("log in screen")
              ],
            ),
          ),
          CustomTextField(
              label: "Mail address",
              onChangedFunc: (newtext) {
                LogInPageModel.instance.mailAddress = newtext;
              },
              isPassword: false),
          CustomTextField(
              label: "Password",
              onChangedFunc: (newtext) {
                LogInPageModel.instance.password = newtext;
              },
              isPassword: true),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Registration is"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Registration()));
                },
                child: Text("Here"),
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  // ログイン
                  Model.instance.user = await Model.instance.logIn(
                      LogInPageModel.instance.mailAddress,
                      LogInPageModel.instance.password);

                  Navigator.of(context).push(MaterialPageRoute(
                      // builder: (context) => Todo(user: userCredential.user!)));
                      builder: (context) => Todo()));
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
              },
              child: Container(
                width: 200,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  "Log in",
                  textAlign: TextAlign.center,
                ),
              )),
        ],
      ),
      // 広告追加
      bottomNavigationBar: AdMob(),
    );
  }
}
