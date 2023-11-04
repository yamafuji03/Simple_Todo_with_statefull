// files
import 'package:todo2/model/variable_function.dart';
import 'package:todo2/pages/todo.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Future<void> login(BuildContext context) async {
//   try {
//     UserCredential userCredential = await FirebaseAuth.instance
//         .signInWithEmailAndPassword(
//             email: LogInPageModel.instance.mailAddress,
//             password: LogInPageModel.instance.password);
//     print('ユーザー情報：${userCredential.user} 終了');

//     // if (userCredential.user != null) {
//     Model.instance.user = userCredential.user!;
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Todo()));
//     // }
//   } on FirebaseAuthException catch (e) {
//     // もしerror code　'user-not-found'ならメールアドレスがない
//     if (e.code == 'user-not-found') {
//       print("メアド見つからない");
//       showDialog(
//           // おまじない
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//                 // ウインドウ左上に表示させるもの
//                 title: Text("エラー"),
//                 // 内容入力
//                 content: Text("メールアドレスが見つかりません"),
//                 // ボタン。任意、書かなくてもいい
//                 actions: [
//                   TextButton(
//                       child: Text("OK"),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       })
//                 ]);
//           });
//       // もしerror code 'wrong-password'ならパスワード間違ってる
//     } else if (e.code == 'wrong-password') {
//       showDialog(
//           // おまじない
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//                 // ウインドウ左上に表示させるもの
//                 title: Text("エラー"),
//                 // 内容入力
//                 content: Text("パスワードが違います"),
//                 // ボタン。任意、書かなくてもいい
//                 actions: [
//                   TextButton(
//                       child: Text("OK"),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       })
//                 ]);
//           });
//     } else {
//       showDialog(
//           // おまじない
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//                 // ウインドウ左上に表示させるもの
//                 title: Text("ログインエラー"),
//                 // 内容入力
//                 content: Text("ログインエラー"),
//                 // ボタン。任意、書かなくてもいい
//                 actions: [
//                   TextButton(
//                       child: Text("OK"),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       })
//                 ]);
//           });
//     }
//     ;
//   }
// }
