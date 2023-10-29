// files
import 'package:todo2/view_model/middle/admob.dart';
import 'package:todo2/model/variable_function.dart';

// packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Todo extends StatefulWidget {
  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        // 指定したuser.uidのデータを取得する
        stream: Model.instance.db
            .collection(Model.instance.user.uid)
            .orderBy('order')
            .snapshots(),
        // おまじない
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text("To Do List"),
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
                          title: Text("Create mode"),
                          // 内容入力
                          content: TextField(
                            onChanged: (newtext) {
                              TodoModel.instance.newItem = newtext;
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
                                  if (TodoModel.instance.newItem != "") {
                                    final randomId = Model.instance
                                        .makeRandomId(Model.instance.user);

                                    Model.instance.db
                                        .collection(Model.instance.user.uid)
                                        .doc(randomId)
                                        .set({
                                      "item": TodoModel.instance.newItem,
                                      'id': randomId,
                                      'order': snapshot.data!.docs.length,
                                      'done': false,
                                      'createdAt': Timestamp.now()
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
            bottomNavigationBar: AdMob(),
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
          Model.instance.db
              .collection(Model.instance.user.uid)
              .doc(moveId)
              .update({
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
              Model.instance.db
                  .collection(Model.instance.user.uid)
                  .doc(otherId)
                  .update({
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
              Model.instance.db
                  .collection(Model.instance.user.uid)
                  .doc(otherId)
                  .update({
                'order': i + 1,
              });
            }
          }

          Model.instance.db
              .collection(Model.instance.user.uid)
              .doc(moveId)
              .update({
            // newIndexをそのままorder番号にする
            'order': newIndex,
          });
        }
      },
      // コレクションIDにあるドキュメントの最大値がアイテムカウント
      itemCount: snapshot.data!.docs.length,
      // itemCount分indexが回る
      itemBuilder: (BuildContext context, int index) {
        // 毎回「snapshot.data!.docs」と書くのはだるいので省略させる。
        DocumentSnapshot doc = snapshot.data!.docs[index];
        // dismissibleでリストのスワイプを実装。keyプロパティを書く必要がある
        return Dismissible(
            // ドキュメントIDの特定し、リストの特定をするdocIDを取得
            key: Key(doc.id),
            // 左から右にスワイプしたときの背景（削除）
            background: Container(
              color: Colors.red,
              child: Icon(Icons.delete),
              alignment: Alignment.centerLeft,
            ),
            // 右にスワイプしかさせない設定
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              // スワイプ方向が左から右の場合の処理
              if (direction == DismissDirection.startToEnd) {
                // ランダムに生成したドキュメントIDを取得
                final field_id = doc.id;
                // Firestoreからfield_idからドキュメントIDを取得してドキュメントを削除
                Model.instance.db
                    .collection(Model.instance.user.uid)
                    .doc(field_id)
                    .delete();

                // 最終的にはしたでいける。あと変数変えるだけ
                // documentの個数をリストで取得
                // List listDoc = snapshot.data!.docs; //queryスナップショットでやったら？
                List<DocumentSnapshot> listDoc =
                    snapshot.data!.docs; //queryスナップショットでやったら？

                // デリートしたのに上のリストではデリートする前のリストを取得してしまうため、デリートした要素をリスト上でも削除する
                listDoc.removeAt(index);

                // リストの個数を取得
                int docCount = listDoc.length;
                // 削除したリストのindex番号とリストの個数が違ってたら処理が実行。リストのindexとドキュメント数が一緒だったらスルーする
                if (index != docCount) {
                  // docCountは１始まり、カウンタ変数は0始まりだからマイナス１で帳尻合わせ
                  for (int i = 0; i <= docCount - 1; i = i + 1) {
                    Model.instance.db
                        .collection(Model.instance.user.uid)
                        .doc(listDoc[i].id) //ここは１個から全てのドキュメントを更新していくため、
                        // 変数doc（指定したドキュメント）「 DocumentSnapshot doc = snapshot.data!.docs[index];」は使用できないため、フルで全部書く
                        .update({
                      'order': i,
                    });
                  }
                }
              }
            },
            child: ListTile(
              // それぞのdocumentに入ってるのitemの中身を表示
              title: Text(doc["item"]),
              subtitle: Text(
                '${DateFormat('yyyy/MM/dd HH:mm').format(doc['createdAt'].toDate())}',
                style: TextStyle(fontSize: 11),
              ),

              // order確認のために使用
              // Text('Order :${snapshot.data!.docs[index]['order'].toString()}'),

              trailing: Wrap(
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            // おまじない
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  // ウインドウ左上に表示させるもの
                                  title: Text("Edit mode"),
                                  // 内容入力
                                  content: TextField(
                                    onChanged: (newText) {
                                      TodoModel.instance.newItem = newText;
                                    },
                                  ),
                                  // ボタン。任意。
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
                                          if (TodoModel.instance.newItem !=
                                              "") {
                                            Model.instance.db
                                                .collection(
                                                    Model.instance.user.uid)
                                                .doc(doc.id)
                                                .update({
                                              "item":
                                                  TodoModel.instance.newItem,
                                              'done': false,
                                              'createdAt': Timestamp.now()
                                            });
                                          }
                                          ;
                                          Navigator.pop(context);
                                        })
                                  ]);
                            });
                      },
                      icon: Icon(Icons.edit)),
                  IconButton(
                    onPressed: () {
                      if (doc['done'] == false) {
                        Model.instance.db
                            .collection(Model.instance.user.uid)
                            .doc(doc.id)
                            .update({'done': true});
                      } else {
                        Model.instance.db
                            .collection(Model.instance.user.uid)
                            .doc(doc.id)
                            .update({'done': false});
                      }
                    },
                    icon: doc['done'] == true
                        ? Icon(Icons.check, color: Colors.blue.shade500)
                        : Icon(Icons.check),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
