import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo2/main.dart';

class Registration extends StatelessWidget {
  String mailAddress = "";
  String password = "";
  String passwordCheck = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新規登録"),
      ),
      body: Column(
        children: [
          CustomTextField(
              label: "mail address",
              onChangedFunc: (newtext) {
                mailAddress = newtext;
              },
              isPassword: false),
          CustomTextField(
              label: "password",
              onChangedFunc: (newtext) {
                password = newtext;
              },
              isPassword: true),
          CustomTextField(
              label: "comfirm password",
              onChangedFunc: (newtext) {
                passwordCheck = newtext;
              },
              isPassword: true),
          ElevatedButton(
              onPressed: () async {
                if (password != passwordCheck) {
                  showDialog(
                      // おまじない
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            // ウインドウ左上に表示させるもの
                            title: Text("エラー"),
                            // 内容入力
                            content: Text("パスワードを正しく入力してください！"),
                            // ボタン。任意、書かなくてもいい
                            actions: [
                              TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ]);
                      });
                } else {
                  if (mailAddress != null && password != null) {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: mailAddress, password: password);

                      final User user = userCredential.user!;
                      FirebaseFirestore.instance
                          .collection(user.uid)
                          .doc()
                          .set({"item": "ToDoを始めよう", "done": false});

                      print("登録完了");
                      showDialog(
                          // おまじない
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                // ウインドウ左上に表示させるもの
                                title: Text("登録しました"),
                                // 内容入力
                                content: Text("登録完了しました"),
                                // ボタン。任意、書かなくてもいい
                                actions: [
                                  TextButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ]);
                          });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == "weak-password") {
                        print("パスワード短すぎ");
                        showDialog(
                            // おまじない
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  // ウインドウ左上に表示させるもの
                                  title: Text("エラー"),
                                  // 内容入力
                                  content: Text("パスワードが短すぎます"),
                                  // ボタン。任意、書かなくてもいい
                                  actions: [
                                    TextButton(
                                        child: Text("OK"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })
                                  ]);
                            });
                      } else if (e.code == "email-already-in-use") {
                        print("メール使われてる");
                        showDialog(
                            // おまじない
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  // ウインドウ左上に表示させるもの
                                  title: Text("エラー"),
                                  // 内容入力
                                  content: Text("このメールアドレスは既に使用されてます"),
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
                    } catch (e) {
                      print("その他エラー");
                      showDialog(
                          // おまじない
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                // ウインドウ左上に表示させるもの
                                title: Text("エラー"),
                                // 内容入力
                                content: Text(e.toString()),
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
                  } else {}
                }
              },
              child: Container(
                width: 200,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  "新規登録",
                  textAlign: TextAlign.center,
                ),
              )),
        ],
      ),
    );
  }
}
