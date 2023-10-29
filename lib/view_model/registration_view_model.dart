import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo2/model/variable_function.dart';

Future<void> registrationButton(BuildContext context) async {
  if (RegistrationModel.instance.passwordRegistration !=
      RegistrationModel.instance.passwordCheckRegistration) {
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
    if (RegistrationModel.instance.mailAddressRegistration != "" &&
        RegistrationModel.instance.passwordRegistration != "") {
      try {
        // メールアドレスとパスワードの登録
        Model.instance.user = await RegistrationModel.instance
            .registerIdAndPassword(
                RegistrationModel.instance.mailAddressRegistration,
                RegistrationModel.instance.passwordRegistration);

        // ランダムに生成されたドキュメントナンバーを取得
        final randomId0 = Model.instance.makeRandomId(Model.instance.user);
        final randomId1 = Model.instance.makeRandomId(Model.instance.user);
        final randomId2 = Model.instance.makeRandomId(Model.instance.user);
        final randomId3 = Model.instance.makeRandomId(Model.instance.user);

        // 新規登録したときに例としてのtodoリストを１個作成する。このとき上で取得したDocIDをフィールド内の"id"に転記する
        Model.instance.db
            .collection(Model.instance.user.uid)
            .doc(randomId0)
            .set({
          "item": "Add new Todo on the bottom button",
          "id": randomId0,
          'order': 0,
          'done': false,
          'createdAt': Timestamp.now()
        });

        Model.instance.db
            .collection(Model.instance.user.uid)
            .doc(randomId1)
            .set({
          "item": "Edit and check with the right side",
          "id": randomId1,
          'order': 1,
          'done': false,
          'createdAt': Timestamp.now()
        });

        Model.instance.db
            .collection(Model.instance.user.uid)
            .doc(randomId2)
            .set({
          "item": "Swipe for delete a list",
          "id": randomId2,
          'order': 2,
          'done': false,
          'createdAt': Timestamp.now()
        });
        Model.instance.db
            .collection(Model.instance.user.uid)
            .doc(randomId3)
            .set({
          "item": "You can move lists. Give it a try!",
          "id": randomId3,
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
                    content: Text("The email address is already used"),
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
}
