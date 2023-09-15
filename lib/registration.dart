import 'package:flutter/material.dart';
import 'package:todo2/main.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新規登録"),
      ),
      body: Column(
        children: [
          CustomTextField(label: "mail address"),
          CustomTextField(label: "パスワード"),
          CustomTextField(label: "パス確認"),
          ElevatedButton(
              onPressed: () {},
              child: Container(
                width: 200,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  "新規登録",
                  textAlign: TextAlign.center,
                ),
              ))
        ],
      ),
    );
  }
}
