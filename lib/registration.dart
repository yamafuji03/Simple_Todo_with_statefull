// files
import 'package:todo2/admob.dart';
import 'package:todo2/format.dart';
// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo2/variable.dart';

class Registration extends StatelessWidget {
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
                  Variable.instance.mailAddressRegistration = newtext;
                },
                isPassword: false),
            CustomTextField(
                label: "Password",
                onChangedFunc: (newtext) {
                  Variable.instance.passwordRegistration = newtext;
                },
                isPassword: true),
            CustomTextField(
                label: "Comfirm password",
                onChangedFunc: (newtext) {
                  Variable.instance.passwordCheckRegistration = newtext;
                },
                isPassword: true),
            ElevatedButton(
                onPressed: () async {
                  if (Variable.instance.passwordRegistration !=
                      Variable.instance.passwordCheckRegistration) {
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
                    if (Variable.instance.mailAddressRegistration != "" &&
                        Variable.instance.passwordRegistration != "") {
                      try {
                        // メールアドレスとパスワードの登録
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email:
                                    Variable.instance.mailAddressRegistration,
                                password:
                                    Variable.instance.passwordRegistration);
                        // おまじない
                        final User user = userCredential.user!;
                        // ランダムに生成されたドキュメントナンバーを取得
                        final randomid0 = FirebaseFirestore.instance
                            .collection(user.uid)
                            .doc()
                            .id;
                        final randomid1 = FirebaseFirestore.instance
                            .collection(user.uid)
                            .doc()
                            .id;
                        final randomid2 = FirebaseFirestore.instance
                            .collection(user.uid)
                            .doc()
                            .id;
                        final randomid3 = FirebaseFirestore.instance
                            .collection(user.uid)
                            .doc()
                            .id;

                        // 新規登録したときに例としてのtodoリストを１個作成する。このとき上で取得したDocIDをフィールド内の"id"に転記する

                        FirebaseFirestore.instance
                            .collection(user.uid)
                            .doc(randomid0)
                            .set({
                          "item": "Add new Todo on the bottom button",
                          "id": randomid0,
                          'order': 0,
                          'done': false,
                          'createdAt': Timestamp.now()
                        });

                        FirebaseFirestore.instance
                            .collection(user.uid)
                            .doc(randomid1)
                            .set({
                          "item": "Edit and check with the right side",
                          "id": randomid1,
                          'order': 1,
                          'done': false,
                          'createdAt': Timestamp.now()
                        });

                        FirebaseFirestore.instance
                            .collection(user.uid)
                            .doc(randomid2)
                            .set({
                          "item": "Swipe for delete a list",
                          "id": randomid2,
                          'order': 2,
                          'done': false,
                          'createdAt': Timestamp.now()
                        });
                        FirebaseFirestore.instance
                            .collection(user.uid)
                            .doc(randomid3)
                            .set({
                          "item": "You can move lists. Give it a try!",
                          "id": randomid3,
                          'order': 3,
                          'done': false,
                          'createdAt': Timestamp.now()
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
                                    content: Text(
                                        "The email address is already used"),
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
        bottomNavigationBar: AdMob());
  }
}
