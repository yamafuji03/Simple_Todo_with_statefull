import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Todo extends StatefulWidget {
  User user;
  Todo({required this.user});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  String newitem = "";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        // 指定したuser.emailのデータを取得する
        stream: FirebaseFirestore.instance
            .collection(widget.user.email!)
            .snapshots(),
        // おまじない
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text("ToDo"),
              // 戻るボタンの非表示
              automaticallyImplyLeading: false,
            ),
            // 三項演算子で、もしデータがあるなら、listview,ないならローディング中のクルクル表示
            body: snapshot.hasData
                ? ListView.builder(
                    // コレクションIDにあるドキュメントの最大値がアイテムカウント
                    itemCount: snapshot.data!.docs.length,
                    //おまじない。考えなくていい。
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
                            // final documentId = snapshot.data!.docs[index].id;
                            // フィールド上にID keyとして記録したドキュメントIDを取得
                            final field_id = snapshot.data!.docs[index]['id'];

                            // Firestoreからfield_idからドキュメントIDを取得してドキュメントを削除
                            FirebaseFirestore.instance
                                .collection(widget.user.email!)
                                .doc(field_id)
                                .delete();
                          }
                        },
                        child: ListTile(
                          // それぞのdocumentに入ってるのitemの中身を表示
                          title: Text(snapshot.data!.docs[index]["item"]),
                          // doneの中がtrueなら何も表示しない　三項演算子
                          trailing: Icon(Icons.check),
                          onTap: () {},
                        ),
                      );
                    },
                  )
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
                                        .collection(widget.user.email!)
                                        .doc()
                                        .id;
                                    FirebaseFirestore.instance
                                        .collection(widget.user.email!)
                                        .doc(randomid)
                                        .set({
                                      "item": newitem,
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
