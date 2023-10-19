// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Todo extends StatefulWidget {
  User user;
  Todo({required this.user});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final db = FirebaseFirestore.instance;
  String newitem = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        // 指定したuser.emailのデータを取得する
        stream: db.collection(widget.user.email!).orderBy('order').snapshots(),
        // おまじない
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text("ToDo"),
              // 戻るボタンの非表示
              automaticallyImplyLeading: false,
            ),
            // 三項演算子で、もしデータがあるなら、listview,ないならローディング中のクルクル表示
            body: buildBody(context, snapshot),
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
                                    final randomid = db
                                        .collection(widget.user.email!)
                                        .doc()
                                        .id;

                                    db
                                        .collection(widget.user.email!)
                                        .doc(randomid)
                                        .set({
                                      "item": newitem,
                                      'id': randomid,
                                      'order': snapshot.data!.docs.length,
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

  Widget buildBody(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
        height: 50,
        width: 50,
      );
    }

    return ReorderableListView.builder(
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          // 動かすドキュメントIDを取得
          final moveId = snapshot.data!.docs[oldIndex].id;
          db.collection(widget.user.email!).doc(moveId).update({
            // newIndexだと最大値プラス１が取れてしまうため、マイナス１で移動先リストと同じindexになるように調整
            'order': newIndex - 1,
          });

          // ここでforでそれ以外のorderをマイナス１にする
          // 始まりを「１」とするのはorderの値をマイナス１してることから１始まりにしないとorder番号がマイナスになる可能性が出るから
          for (int i = 1; i <= newIndex - 1; i = i + 1) {
            // 他のドキュメントのIDを取得
            final otherId = snapshot.data!.docs[i].id;
            // 移動させたリストと古いリストのorderが被っているから、もし移動したIDとiのIDが違うなら処理を実行とする。
            if (moveId != otherId) {
              db.collection(widget.user.email!).doc(otherId).update({
                // orderをi-1にして選択されていないリストの中にあるorderを１ずらす
                'order': i - 1,
              });
            }
          }
        } else {
          // 動かすドキュメントIDを取得
          final moveId = snapshot.data!.docs[oldIndex].id;

          // ここでforでそれ以外のorderをプラス１にする
          // 始まりを「newIndex」として仮に3から2へ移動する際にorder1には影響が出ないようにする
          for (int i = newIndex; i <= oldIndex; i = i + 1) {
            // 他のドキュメントのIDを取得
            final otherId = snapshot.data!.docs[i].id;
            // 移動させたリストと古いリストのorderが被ってないなら、orderをプラス１して並び替える。
            if (moveId != otherId) {
              db.collection(widget.user.email!).doc(otherId).update({
                'order': i + 1,
              });
            }
          }

          db.collection(widget.user.email!).doc(moveId).update({
            // newIndexをそのままorder番号にする
            'order': newIndex,
          });
        }
      },
      // コレクションIDにあるドキュメントの最大値がアイテムカウント
      itemCount: snapshot.data!.docs.length,
      // itemCount分indexが回る
      itemBuilder: (BuildContext context, int index) {
        // dismissibleでリストのスワイプを実装。keyプロパティを書く必要がある
        return Dismissible(
          // ドキュメントIDの特定し、リストの特定をするdocIDを取得
          key: Key(snapshot.data!.docs[index].id),
          // 左から右にスワイプしたときの背景（削除）
          background: Container(
            color: Colors.red,
            child: Icon(Icons.delete),
            alignment: Alignment.centerLeft,
          ),
          // 右にスワイプしかさせない設定
          direction: DismissDirection.startToEnd,
          // 右から左にスワイプしたときの背景（アーカイブ）
          // secondaryBackground: Container(color: Colors.teal),
          onDismissed: (direction) {
            // スワイプ方向が左から右の場合の処理
            if (direction == DismissDirection.startToEnd) {
              // ランダムに生成したドキュメントIDを取得
              final field_id = snapshot.data!.docs[index].id;
              // Firestoreからfield_idからドキュメントIDを取得してドキュメントを削除
              db.collection(widget.user.email!).doc(field_id).delete();

              // documentの個数をリストで取得
              List doc = snapshot.data!.docs;
              // デリートしたのに上のリストではデリートする前のリストを取得してしまうため、デリートした要素をリスト上でも削除する
              doc.removeAt(index);

              // リストの個数を取得
              int docCount = doc.length;
              // 削除したリストのindex番号とリストの個数が違ってたら処理が実行。リストのindexとドキュメント数が一緒だったらスルーする
              if (index != docCount) {
                // docCount - 1分だけのorderが各docに再代入される
                for (int i = 0; i <= docCount - 1; i = i + 1) {
                  // db.collection(widget.user.email!).doc(doc[index].id).update({
                  db.collection(widget.user.email!).doc(doc[i].id).update({
                    'order': i,
                  });
                }
              }
            }
          },
          child: ListTile(
            // それぞのdocumentに入ってるのitemの中身を表示
            title: Text(snapshot.data!.docs[index]["item"]),
            subtitle: Text(
                'Order :${snapshot.data!.docs[index]['order'].toString()}'),
            // doneの中がtrueなら何も表示しない　三項演算子
            trailing: Icon(Icons.check),
            onTap: () {},
          ),
        );
      },
    );
  }
}
