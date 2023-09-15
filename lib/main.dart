import 'package:flutter/material.dart';
import 'package:todo2/registration.dart';

void main() {
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
  const MyHomePage({super.key});

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
                Text("log in")
              ],
            ),
          ),
          CustomTextField(
            label: "mail address",
          ),
          CustomTextField(label: "password"),
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
              onPressed: () {},
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

  CustomTextField({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (newtext) {},
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      ),
    );
  }
}
