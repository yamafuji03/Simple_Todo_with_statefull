// files
import 'package:todo2/model/variable_function.dart';

// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo2/view_model/admob.dart';
import 'package:todo2/view_model/todo_view_model.dart';

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
            body: buildBody(context, snapshot),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                createList(context, snapshot);
              },
              child: Icon(Icons.add),
            ),
            bottomNavigationBar: AdMob(),
          );
        });
  }
}
