// files
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo2/registration.dart';
import 'package:todo2/firebase_options.dart';
import 'package:todo2/todo.dart';
// packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  String mailAddress = "example@gmail.com";
  String password = "aaaaaa";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  "ToDoアプリ",
                  style: TextStyle(fontSize: 50),
                ),
                Text("log in shitekudasai")
              ],
            ),
          ),
          CustomTextField(
              label: "mailaddress",
              onChangedFunc: (newtext) {
                mailAddress = newtext;
              },
              isPassword: false),
          CustomTextField(
              label: "password",
              onChangedFunc: (newtext) {
                password = newtext;
              },
              isPassword: true),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("新規登録は"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Registration()));
                },
                child: Text("こちら"),
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: mailAddress, password: password);
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Todo()));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print("メアド見つからない");
                    showDialog(
                        // おまじない
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              // ウインドウ左上に表示させるもの
                              title: Text("エラー"),
                              // 内容入力
                              content: Text("メールアドレスが見つかりません"),
                              // ボタン。任意、書かなくてもいい
                              actions: [
                                TextButton(
                                    child: Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    })
                              ]);
                        });
                  } else if (e.code == 'wrong-password') {
                    showDialog(
                        // おまじない
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              // ウインドウ左上に表示させるもの
                              title: Text("エラー"),
                              // 内容入力
                              content: Text("パスワードが違います"),
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
                  ;
                }
              },
              child: Container(
                width: 200,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  "ログイン",
                  textAlign: TextAlign.center,
                ),
              ))
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  String label;
  void Function(String text) onChangedFunc;
  bool isPassword;

  CustomTextField(
      {required this.label,
      required this.onChangedFunc,
      required this.isPassword});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (newtext) {
          onChangedFunc(newtext);
        },
        obscureText: isPassword ? true : false,
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }
}
