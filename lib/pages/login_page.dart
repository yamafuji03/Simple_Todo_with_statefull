// files
import 'package:todo2/pages/todo.dart';
import 'package:todo2/view_model/admob.dart';
import 'package:todo2/view_model/custom_text_field.dart';
import 'package:todo2/pages/registration.dart';
import 'package:todo2/model/variable_function.dart';
import 'package:todo2/view_model/login_page_view_model.dart';

// packages
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log In Screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  "Simple To Do",
                  style: TextStyle(fontSize: 50),
                ),
                // Text("log in screen")
              ],
            ),
          ),
          CustomTextField(
              label: "Mail address",
              onChangedFunc: (newtext) {
                LogInPageModel.instance.mailAddress = newtext;
              },
              isPassword: false),
          CustomTextField(
              label: "Password",
              onChangedFunc: (newtext) {
                LogInPageModel.instance.password = newtext;
              },
              isPassword: true),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Registration is"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Registration()));
                },
                child: Text("Here"),
              ),
            ],
          ),
          ElevatedButton(
            child: Container(
              width: 200,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                "Log in",
                textAlign: TextAlign.center,
              ),
            ),
            onPressed: () async {
              await loginButton(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Todo()));
            },
          ),
        ],
      ),
      // 広告追加
      // bottomNavigationBar: AdMob(),
    );
  }
}
