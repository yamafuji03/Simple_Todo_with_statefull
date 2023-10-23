import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Model {
  // 他からインスタンス作成不可をする記述
  Model._();
  // クラス内にこのクラスのインスタンスを生成
  static final instance = Model._();

  // 変数一覧
  // 全てにまたがっているもの
  final db = FirebaseFirestore.instance;
}

class LogInPageModel {
  // 他からインスタンス作成不可をする記述
  LogInPageModel._();
  // クラス内にこのクラスのインスタンスを生成
  static final instance = LogInPageModel._();

  // 変数
  String mailAddress = 'example@gmail.com'; //この２個はアプリ登録する時に''にしていること
  String password = 'aaaaaa';
}

class RegistrationModel {
  // 他からインスタンス作成不可をする記述
  RegistrationModel._();
  // クラス内にこのクラスのインスタンスを生成
  static final instance = RegistrationModel._();

  // 変数
  String mailAddressRegistration = '';
  String passwordRegistration = '';
  String passwordCheckRegistration = '';

  // // 関数
  String makeRandomId(User user) {
    // 個々のuid内でランダムIDを生成し、戻り値をStringとして返す
    return FirebaseFirestore.instance.collection(user.uid).doc().id;
  }

  // void registerIdAndPassword(String email, String password)async {
  //  await FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(email: email, password: password);}
}

class TodoModel {
  // 他からインスタンス作成不可をする記述
  TodoModel._();
  // クラス内にこのクラスのインスタンスを生成
  static final instance = TodoModel._();

  // 変数
  String newItem = '';
}
