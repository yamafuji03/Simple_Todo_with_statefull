// packages
import 'package:flutter/material.dart';

// textFormFieldを使ったテンプレート
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
