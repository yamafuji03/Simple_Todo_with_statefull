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
        title: Text("Create Acount Screen"),
      ),
      body: Column(
        children: [
          CustomTextField(
              label: "Mail address",
              onChangedFunc: (newtext) {
                mailAddress = newtext;
              },
              isPassword: false),
          CustomTextField(
              label: "Password",
              onChangedFunc: (newtext) {
                password = newtext;
              },
              isPassword: true),
          CustomTextField(
              label: "Comfirm password",
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
                            title: Text('Error'),
                            // 内容入力
                            content: Text('Hit your correct password'),
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
                  if (mailAddress != "" && password != "") {
                    try {
                      // メールアドレスとパスワードの登録
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: mailAddress, password: password);
                      // おまじない
                      final User user = userCredential.user!;
                      // ランダムに生成されたドキュメントナンバーを取得
                      final randomid = FirebaseFirestore.instance
                          .collection(user.email!)
                          .doc()
                          .id;
                      // 新規登録したときに例としてのtodoリストを１個作成する。このとき上で取得したDocIDをフィールド内の"id"に転記する
                      FirebaseFirestore.instance
                          .collection(user.email!)
                          .doc(randomid)
                          .set({
                        "item": "Let's get your Todo's started",
                        "id": randomid,
                        'order': 0,
                      });

                      print("登録完了");
                      showDialog(
                          // おまじない
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                // ウインドウ左上に表示させるもの
                                title: Text('Complete'),
                                // 内容入力
                                content: Text('Registration is completed'),
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
                                  title: Text("Error"),
                                  // 内容入力
                                  content: Text("Password is too short"),
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
                                  title: Text("Error"),
                                  // 内容入力
                                  content:
                                      Text("The email address is already used"),
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
                                title: Text('Error'),
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
                  'Create!',
                  textAlign: TextAlign.center,
                ),
              )),
        ],
      ),
    );
  }
}
