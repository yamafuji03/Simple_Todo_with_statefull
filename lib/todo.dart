import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Todo extends StatelessWidget {
  User user;
  Todo({required this.user});
  String newitem = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        // 指定したuser.uidのデータを取得する
        stream: FirebaseFirestore.instance.collection(user.email!).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text("ToDo"),
              automaticallyImplyLeading: false,
            ),
            // 三項演算子で、もしデータがあるなら、listview,ないならローディング中のクルクル表示
            body: snapshot.hasData
                ? ListView.builder(
                    // コレクションIDにあるドキュメントの最大値がアイテムカウント
                    itemCount: snapshot.data!.docs.length,
                    //おまじない。考えなくていい。
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        // それぞのdocumentに入ってるのitemの中身を表示
                        title: Text(snapshot.data!.docs[index]["item"]),
                        // doneの中がtrueなら何も表示しない　三項演算子
                        trailing: Icon(Icons.check),

                        onTap: () {},

                        onLongPress: () {
                          // ロングタップしたときに選択したリストを削除するコード

                          // ランダムに生成したドキュメントIDを取得
                          // final documentId =
                          //     snapshot.data!.docs[index].id;
                          // フィールド上にID keyとして記録したドキュメントIDを取得
                          final documentId = snapshot.data!.docs[index]['id'];

                          // Firestoreからドキュメントを削除
                          FirebaseFirestore.instance
                              .collection(user.email!)
                              .doc(documentId)
                              .delete()
                              .then((_) {
                            // 成功時の処理
                            print('ドキュメントが削除されました');
                          }).catchError((error) {
                            // エラー時の処理
                            print('エラーが発生しました: $error');
                          });
                        },
                      );
                    })
                // リストの中が何もないならクルクルの表示
                : SizedBox(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    height: 50,
                    width: 50,
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                    // おまじない
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          // ウインドウ左上に表示させるもの
                          title: Text("ToDo追加画面"),
                          // 内容入力
                          content: TextField(
                            onChanged: (newtext) {
                              newitem = newtext;
                            },
                          ),
                          // ボタン。任意、書かなくてもいい
                          actions: [
                            // 「Navigator.pop(context);」は何も起きないで暗くなったページが元に戻る
                            TextButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  if (newitem != "") {
                                    final randomid = FirebaseFirestore.instance
                                        .collection(user.email!)
                                        .doc()
                                        .id;
                                    FirebaseFirestore.instance
                                        .collection(user.email!)
                                        .doc(randomid)
                                        .set({
                                      "item": newitem,
                                      "done": false,
                                      'id': randomid,
                                    });
                                  }
                                  ;
                                  Navigator.pop(context);
                                })
                          ]);
                    });
              },
              child: Icon(Icons.add),
            ),
          );
        });
  }
}
